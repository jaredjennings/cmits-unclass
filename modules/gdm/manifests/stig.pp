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
# \subsection{STIG-required configuration}
#
# The way to configure GDM and the X servers it starts varies between RHEL5 and
# RHEL6.

class gdm::stig {
    if($gdm_installed == 'true') {
        case $osfamily {
            RedHat: {
                case $operatingsystemrelease {
                    /^6.*/: { include gdm::stig::rhel6 }
                    /^5.*/: { include gdm::stig::rhel5 }
                    default: { unimplemented() }
                }
            }
            default: { unimplemented() }
        }
    }
}
