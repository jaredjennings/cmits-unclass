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
class fun::no::darwin_10_9 {

# \implements{mlionstig}{OSX8-00-00470}%
# Remove the Chess application from Macs.
    file { '/Applications/Chess.app':
        ensure => absent,
        recurse => true,
        force => true,
    }
# \implements{mlionstig}{OSX8-00-00480}%
# Remove the Game Center application from Macs.
    file { '/Applications/Game Center.app':
        ensure => absent,
        recurse => true,
        force => true,
    }

# \notapplicable{mlionstig}{OSX8-00-00481}%
# ``This requirement is N/A if requirement \mlionstig{OSX8-00-00480} is
# met.''
}
