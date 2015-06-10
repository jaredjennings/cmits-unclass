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
# \subsection{Disallow admins from unlocking user screens}
#
# \implements{macosxstig}{OSX00200 M6}%
# \implements{mlionstig}{OSX8-00-00935}%
# Disable administrative accounts from unlocking other users' screens.
#
# Mac OS X has a setting which when turned on lets not only the user who locked
# the screen unlock it, but also any admin. The STIG requires that this setting
# be turned off. Admins are still able to unlock their own screens, just not
# those of other users.

class screensaver::no_admin_unlock {
    case $::macosx_productversion_major {
        "10.6": {
            mac_plist_value { 'disable_admin_screensaver_unlock':
                file => '/etc/authorization',
                key => ['rights', 'system.login.screensaver', 'rule'],
                value => 'authenticate-session-owner',
            }
        }
        "10.9": {
            mac_authz_plist_value { 'no admin unlock screensaver':
                right => 'system.login.screensaver',
                key => ['rule'],
                value => ['authenticate-session-owner', ''],
            }
        }
        default: { unimplemented() }
    }
}

