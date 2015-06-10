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
# \section{Graphical login}
#
# Some hosts should have graphical login. Others should not. This class enables
# or disables that feature.
#
# This class only turns graphical login on or off; it does not apply
# STIG-related requirements to the mechanism of graphical login.
# See~\S\ref{module_gdm} for that.

class graphical_login {
    case $::osfamily {
        'RedHat': {
            package { 'gdm':
                ensure => installed,
            }
# Fortunately this is the one thing RHEL5 and RHEL6 have in common
# between their init systems.
            augeas { 'default_runlevel_5':
                context => '/files/etc/inittab',
                changes => 'set id/runlevels 5',
            }
        }
# Mac OS X always has graphical login.        
        'Darwin': {}
        default: { unimplemented() }
    }
}
