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
# \subsection{Remove a previous group allowance}
#
# Stop letting members of a UNIX group use USB mass storage without
# authenticating as admins.
#
# Note that this does not explicitly disallow them: it merely undoes what
# \verb!usb::mass_storage::allow_group! does. That's why this is not called
# \verb!disallow_group!.
#
# Usage example:
# \begin{verbatim}
#     usb::mass_storage::unallow_group { "accounting": }
# \end{verbatim}
# \dinkus

define usb::mass_storage::unallow_group() {
    $group = $name
    case $osfamily {
        RedHat: {
            case $operatingsystemrelease {

                /^6\..*/: {
    file { "/etc/polkit-1/localauthority/90-mandatory.d/\
60-mil.af.eglin.afseo.group-${group}-udisks.pkla":
            ensure => absent,
    }
                }

                /^5\..*/: {
    unimplemented()
                }

                default: { unimplemented() }
            }
        }
        default: { unimplemented() }
    }
}
