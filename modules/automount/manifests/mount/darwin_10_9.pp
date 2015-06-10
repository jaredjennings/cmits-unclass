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
# \subsection{Adding an automount entry under Mavericks}
#
# Don't use this directly: use \verb!automount::mount! and let it sort out what
# platform you are on. Documentation is above.

define automount::mount::darwin_10_9($from, $under='', $ensure='present', $options=[]) {

    include augeas

    $hostpath = split($from, ':')
    $host = $hostpath[0]
    $path = $hostpath[1]

# \implements{unixsrg}{GEN002420,GEN005900} Ensure the \verb!nosuid! option
# is used when mounting an NFS filesystem.
#
# \implements{unixsrg}{GEN002430} Ensure the \verb!nodev! option is used when
# mounting an NFS filesystem.
    $stig_required = "
set \$here/opt[last()+1] nosuid
set \$here/opt[last()+1] nodev
"

    $extra = inline_template("
<% @options.flatten.each do |o| %>
set \$here/opt[last()+1] '<%=o%>'
<% end %>
")

    $set_values_script = "
rm  \$here/opt
${stig_required}
${extra}
rm  \$here/location
set \$here/location/1/host ${host}
set \$here/location/1/path ${path}
"

    Augeas {
        lens => 'Automounter.lns',
        incl => '/etc/auto_net',
        context => "/files/etc/auto_net",
        require => File['/etc/auto_net'],
        notify => Service['com.apple.autofsd'],
    }

    case $ensure {
        'present': {
            if $under == '' {
                augeas { "create mount ${name}":
                    onlyif => "match *[.='${name}'] size == 0",
                    changes => "
defnode here 999 '${name}'
${set_values_script}
",
                }
                augeas { "modify mount ${name}":
                    onlyif => "match *[.='${name}'] size > 0",
                    changes => "
defnode here *[.='${name}'] '${name}'
${set_values_script}
",
                }
            }
            else {
                augeas { "fix submount ${name} under ${under}":
                    onlyif => "match *[.='${under}'][mount/*='/${name}'] size > 0",
                    changes => "
defvar top *[.='${under}']
defvar here \$top/mount/*[.='/${name}'][last()]
${set_values_script}
",
                }
                augeas { "create toplevel ${under} and submount ${name}":
                    onlyif => "match *[.='${under}'] size == 0",
                    changes => "
defnode top 999 '${under}'
defnode here \$top/mount/999 '/${name}'
${set_values_script}
",
                }
                augeas { "create submount ${name} under existing toplevel ${under}":
                    onlyif => "match *[.='${under}']/mount/*[.='/${name}'] size == 0",
                    changes => "
defvar top *[.='${under}']
defnode here \$top/mount/999 '/${name}'
${set_values_script}
",
                }
            }
        }
        'absent': {
            augeas { "no_mount_${under}_${name}":
                changes => [
                    "rm *[.='$name']",
                ],
            }
        }
    }
}
