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
# \subsection{Remove user list}
#
# Prevent GDM from showing a list of possible users to log in as.

class gdm::no_user_list {
    if($gdm_installed == 'true') {
        case $osfamily {
            RedHat: {
                case $operatingsystemrelease {
                    /^6\..*/: {
                        include gdm::no_user_list::rhel6
                    }
# GDM 2 (RHEL5) doesn't do user lists.
                    /^5\..*/: { }
                    default: { unimplemented() }
                }
            }
            default: { unimplemented() }
        }
    }
}
