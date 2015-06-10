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
# \subsubsection{Login warnings on Snow Leopard}
# \implements{macosxstig}{OSX00100 M6}%
# Configure the Mac OS Snow Leopard login window to show a login
# warning.

class dod_login_warnings::mac_loginwindow::darwin_10_6 {
    mac_default { 'mac_login_warnings':
        domain => '/Library/Preferences/com.apple.loginwindow',
        key => 'LoginwindowText',
        source => 'puppet:///modules/dod_login_warnings/paragraphs',
    }
}
