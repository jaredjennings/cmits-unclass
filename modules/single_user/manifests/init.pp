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
# \section{Control access to single-user mode}
# Different operating systems do this differently; so first we must pick an
# implementation.
#
# \implements{iacontrol}{DCSS-1} Control access to single-user mode, so that
# ``system initialization'' and ``shutdown... are configured to ensure that the
# system remains in a secure state.''

class single_user {
    case $osfamily {
        RedHat: {
            case $operatingsystemrelease {
                /^6.*/: {
                    include single_user::rhel6
                }
                /^5.*/: {
                    include single_user::rhel5
                }
                default: { unimplemented() }
            }
        }
# \doneby{admins}{iacontrol}{DCSS-1}%
# Under Mac OS X, single-user mode access is controlled by a boot
# password, which must be set from a utility which is run from the Mac
# OS X install disk. This cannot be automated.
        Darwin: {}
        default: { unimplemented() }
    }
}
