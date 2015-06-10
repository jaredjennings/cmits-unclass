# % CMITS - Configuration Management for Information Technology Systems
# % Based on <https://github.com/afseo/cmits>.
# % Copyright 2015 Jared Jennings <mailto:jjennings@fastmail.fm>.
# %
# % Licensed under the Apache License, Version 2.0 (the "License");
# % you may not use this file except in compliance with the License.
# % You may obtain a copy of the License at
# %
# %    http://www.apache.org/licenses/LICENSE-2.0
# %
# % Unless required by applicable law or agreed to in writing, software
# % distributed under the License is distributed on an "AS IS" BASIS,
# % WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# % See the License for the specific language governing permissions and
# % limitations under the License.
# \subsection{Define a printer}
#
# This defined resource type adds or removes CUPS printers, and
# enables or disables them.
#
# It wraps the \verb!lpadmin(8)! command, \emph{q.v.}
#
# Caveats: Since we're running commands using the shell here, don't
# have any apostrophes in any parameters to this define. Printer names
# must not include the strings ``not accepting requests'' or
# ``disabled since.''
#
# Values you can use for the \verb!model! parameter can be listed
# using the CUPS command \verb!lpinfo -m!.

define cups::printer(
    $model,
    $options,
    $uri,
    $description,
    $location,
    $enable=true,
    $ensure=present,
    ) {

    $options_switches = inline_template("<%=
        options.collect {|k,v|
            \"-o '#{k}=#{v}'\"}.sort.join(' ') %>")

    case $ensure {
        'present': {
            exec { "create_printer_${name}":
                command => "lpadmin -p '${name}' \
                    -m '${model}' \
                    ${options_switches} \
                    -u allow:all \
                    -v '${uri}' \
                    -D '${description}' \
                    -L '${location}'",
                creates => "/etc/cups/ppd/${name}.ppd",
            }
            if $enable == true {
                exec { "accept_printer_${name}":
                    command => "cupsaccept '${name}'",
                    require => Exec["create_printer_${name}"],
                    onlyif => "lpstat -a '${name}' | \
                        grep 'not accepting requests'",
                }
                exec { "enable_printer_${name}":
                    command => "cupsenable '${name}'",
                    require => Exec["create_printer_${name}"],
                    onlyif => "lpstat -p '${name}' | \
                        grep 'disabled since'",
                }
            } else {
                exec { "reject_printer_${name}":
                    command => "cupsreject '${name}'",
                    require => Exec["create_printer_${name}"],
                    unless => "lpstat -a '${name}' | \
                        grep 'not accepting requests'",
                }
                exec { "disable_printer_${name}":
                    command => "cupsdisable '${name}'",
                    require => Exec["create_printer_${name}"],
                    unless => "lpstat -p '${name}' | \
                        grep 'disabled since'",
                }
            }
        }
        'absent': {
            exec { "remove_printer_${name}":
                command => "lpadmin -x '${name}'",
                onlyif => "lpstat -p '${name}'",
            }
        }
        default: {
            fail("ensure value must be present or absent")
        }
    }
}
