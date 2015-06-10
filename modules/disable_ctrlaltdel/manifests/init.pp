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
# \section{Disable Ctrl-Alt-Del at console}
# \label{disable_ctrlaltdel}
#
# \implements{rhel5stig}{GEN000000-LNX00580}%
# \implements{iacontrol}{DCSS-1} Ensure that ``shutdowns'' are ``configured to
# ensure that the system remains in a secure state'' by preventing an
# unauthenticated person at the console from rebooting the system.

class disable_ctrlaltdel {
    case $::osfamily {
        'RedHat': {
            case $::operatingsystemrelease {
                /^6\..*/: { require disable_ctrlaltdel::rhel6 }
                /^5\..*/: { require disable_ctrlaltdel::rhel5 }
                default:  { unimplemented() }
            }
        }
        default: { unimplemented() }
    }
}
