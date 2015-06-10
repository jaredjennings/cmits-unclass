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
# \section{Smartcards}
#
# Configure smart card drivers and support.
#
# Application-specific settings may also be necessary.

class smartcard {
    case $::osfamily {
        'RedHat': {
            package { ['pcsc-lite', 'coolkey']:
                ensure => present,
            }
        }
        'Darwin': {
            case $::macosx_productversion_major {
                '10.6': {
                    mac_package { 'OpenSC-0.12.2-10.6-1.dmg':
                        ensure => installed,
                    }
                }
                '10.9': {
                    mac_package { 'OpenSC-0.12.2-10.9hack.dmg':
                        ensure => installed,
                    }
                }
                default: { unimplemented() }
            }
        }
        default: { unimplemented() }
    }
}

