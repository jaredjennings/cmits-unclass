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
# \subsection{Including policy files}
#
# RHEL 6 has sudo 1.8, which supports \verb!#includedir!. To make sudo
# pay attention to a new file in the \verb!sudoers.d! directory, we
# need do nothing. But Snow Leopard only has sudo 1.7.0, so we must
# \verb!#include! each sudo policy file.
#
# This defined resource type does whatever is necessary to make sudo
# pay attention to a file we've placed in the \verb!sudoers.d!.

define sudo::include_policy_file($ensure='present', $sudoers='', $sudoers_d='') {
    require sudo
    include sudo::params

    $d_sudoers = $sudoers ? {
        ''      => $sudo::params::sudoers,
        default => $sudoers,
    }
    $d_sudoers_d = $sudoers_d ? {
        ''      => $sudo::params::sudoers_d,
        default => $sudoers_d,
    }

    case $ensure {
        'absent': {
            case $osfamily {
                'RedHat': {}
                'Darwin': {
                    augeas { "sudoers_exclude_${name}":
                        context => "/files/${d_sudoers}",
                        incl => "${d_sudoers}",
                        lens => 'Sudoers.lns',
                        changes => [
                            "rm #include[.='${d_sudoers_d}/${name}']",
                            ],
                    }
                }
                default: { unimplemented() }
            }
        }
        default: {
            case $osfamily {
                'RedHat': {}
                'Darwin': {
                    augeas { "sudoers_include_${name}":
                        context => "/files/${d_sudoers}",
                        incl => "${d_sudoers}",
                        lens => 'Sudoers.lns',
                        changes => [
                            "set #include[last()+1] '${d_sudoers_d}/${name}'",
                            ],
                        onlyif => "match \
                            #include[.='${d_sudoers_d}/${name}'] size == 0",
                    }
                }
                default: { unimplemented() }
            }
        }
    }
}
