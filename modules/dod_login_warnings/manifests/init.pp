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
# \section{DoD Login Warnings}
# \label{dod_login_warnings}
#
# Install notice and consent warnings.

class dod_login_warnings {
    case $::osfamily {
        'redhat': {
            include dod_login_warnings::console
            include dod_login_warnings::gdm
            include dod_login_warnings::ssh
        }
        'darwin': {
            include dod_login_warnings::mac_loginwindow
# \implements{macosxstig}{OSX00105 M6}%
# Display login banners when the user ``connects to the computer remotely,''
# via SSH.
#
# ``When a user opens a terminal locally,'' \macosxstig{OSX00105 M6} requires
# that ``the user sees the access warning.'' But opening a terminal on a Mac
# does not constitute logging in to the Mac: the user has already done that,
# and has already been warned by the login window before doing so. Because the
# requirement is to ``display the logon banner \emph{prior} to a logon
# attempt,'' we deviate from the published check and fix content here in order
# to fulfill the spirit of compliance.
            include dod_login_warnings::ssh
        }
        default: {
            include dod_login_warnings::console
            include dod_login_warnings::gdm
            include dod_login_warnings::ssh
        }
    }
}
