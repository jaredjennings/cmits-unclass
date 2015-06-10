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
# \subsection{Disable fast user switching}
#
# \implements{macosxstig}{OSX00330 M6}%
# \implements{mlionstig}{OSX8-00-01100}%
# Disable fast user switching on the Mac.

class fast_user_switching::no {
    $fus_domain = '/Library/Preferences/.GlobalPreferences'
    mac_default { "$fus_domain:MultipleSessionEnabled":
        type => bool,
        value => true,
    }
}
