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
# \section{Fast user switching}
#
# Enable fast user switching on the Mac. This contravenes 
# \macosxstig{OSX00330 M6}.
#
# The \verb!menu_style! parameter can have values ``Name,'' ``Short Name'' or
# ``Icon.''

class fast_user_switching($menu_style='Name')  {
    $fus_domain = '/Library/Preferences/.GlobalPreferences'
    mac_default { "$fus_domain:MultipleSessionEnabled":
        type => bool,
        value => true,
    }

    mac_default { "$fus_domain:userMenuExtraStyle":
        type => int,
        value => $menu_style ? {
            'Name' => 0,
            'Short Name' => 1,
            'Icon' => 2,
            default => fail("unknown fast user switching \
menu style $menu_style"),
        },
    }
}
