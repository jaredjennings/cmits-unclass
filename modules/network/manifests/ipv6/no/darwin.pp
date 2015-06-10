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
# \paragraph{Turn off IPv6 under Mac OS X}

class network::ipv6::no::darwin {

# \implements{mlionstig}{OSX8-00-01240}%
# Turn off IPv6 ``if not being used.''
    define on_interface() {
        exec { "turn off IPv6 on ${name}":
            command => "networksetup -setv6off ${name}",
            unless => "networksetup -getinfo ${name} | \
                       grep '^IPv6: Off\$'",
        }
    }
    on_interface { 'Ethernet': }
}
