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
# \subsection{Remove unnecessary users}
#
# \implements{unixsrg}{GEN000290} Remove ``application accounts for
# applications not installed on the system.''
#
# The set of needed system users varies by operating system and release; so,
# likewise, does the set of unnecessary system users.

class user::unnecessary {
    case $osfamily {
        RedHat: {
            case $operatingsystemrelease {
                /^6.*/: { include user::unnecessary::rhel6 }
                /^5.*/: { include user::unnecessary::rhel5 }
                default: { unimplemented() }
            }
        }
        Darwin: {}
        default: { unimplemented() }
    }
}
