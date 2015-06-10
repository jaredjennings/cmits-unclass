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
class root::stig::darwin {
# \implements{mlionstig}{OSX8-00-01230}%
# Make sure the root account is disabled for interactive use.
    exec { 'disable root interactive login':
        command => 'dsenableroot -d',
# dscl should say, ``No such key: AuthenticationAuthority.'' If it
# says anything else, we want to run the command.
        onlyif => 'dscl . -read /Users/root \
                                AuthenticationAuthority \
                   2>&1 | grep -v "^No such key:"',
    }
}
