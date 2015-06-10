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
# \subsubsection{Prerequisites for wrapping 32-bit Mozilla plugins}

class mozilla::wrap_32bit::prerequisites {
    case $::osfamily {
        'RedHat': {
            case $::architecture {
                'x86_64': {
# The package containing the plugin may not know about all the prerequisites
# necessary for it to happen, so it may not pull them in when it's installed.
# We list them here so they will certainly be installed.
                    package { [
                        'nspluginwrapper.i686',
                        'nspluginwrapper.x86_64',
                        'zlib.i686',
# Without these, the Flash plugin and Citrix ICA receiver plugin have
# successfully installed, but failed to actually run under nspluginwrapper.
                        'libcanberra-gtk2.i686',
                        'PackageKit-gtk-module.i686',
                        'gtk2-engines.i686',
                    ]:
                        ensure => present,
                    }
                }
# No wrapping is necessary for 32-bit plugins on a 32-bit system. 
                'i386': {}
                default: { unimplemented() }
            }
        }
        default: { unimplemented() }
    }
}
