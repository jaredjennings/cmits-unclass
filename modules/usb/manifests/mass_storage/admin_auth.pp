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
# \subsection{Require admin password for USB storage}
#
# \implements{unixsrg}{GEN008480} Prevent installation of malicious software or
# exfiltration of data by restricting the use of mass storage to administrators.
#
# (USB mass storage could be disabled entirely from desktop use, but
# admins can become root and use the mount command anyway. As long as we trust
# our vendor to give us correct software, there's no particular advantage in
# slashing a swath of nonfunctionality through the desktop.)
class usb::mass_storage::admin_auth {
    case $osfamily {
        RedHat: {
            case $operatingsystemrelease {

                /^6\..*/: {
    file { "/etc/polkit-1/localauthority/90-mandatory.d/\
50-mil.af.eglin.afseo.admin-udisks.pkla":
        owner => root, group => 0, mode => 0600,
        source => "puppet:///modules/usb/mass_storage/\
admin-udisks.pkla",
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
