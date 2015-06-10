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
# \subsection{Notice of monitoring via graphical login}
#
# \implements{unixsrg}{GEN000402} Show a warning before the login box under
# GDM.
#
# This would normally go under~\S\ref{class_gdm}, but because the text of the
# warning is of legal import and we are inspected on it yearly, it's better to
# keep everything that uses the warning text in one place.

class dod_login_warnings::gdm {

# First, do no harm.
    if($gdm_installed == 'true') {

# RHEL5 and RHEL6 show the banner differently.
        case $osfamily {
            'RedHat': {
                case $operatingsystemrelease {
                    /^6\..*/: {
                        include dod_login_warnings::gdm::rhel6
                    }
                    /^5\..*/: {
                        include dod_login_warnings::gdm::rhel5
                    }
                    default: { unimplemented() }
                }
            }
            default: { unimplemented() }
        }
    }
}
