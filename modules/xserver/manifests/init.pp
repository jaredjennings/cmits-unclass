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
# \section{X Window System server}
#
# Make sure an X server is installed.
#
# The NVIDIA proprietary drivers need the X server installed, but it may be
# surprising for the \verb!nvidia::proprietary! class to silently install an X
# server. So we install it here.

class xserver {
    case $::osfamily {
        'RedHat': {
            case $::operatingsystemrelease {
                /^[56]\..*$/: {
                    package { 'xorg-x11-server-Xorg':
                        ensure => present,
                    }
                }
                default: { unimplemented() }
            }
        }
        'Darwin': {}
        default: { unimplemented() }
    }
}
