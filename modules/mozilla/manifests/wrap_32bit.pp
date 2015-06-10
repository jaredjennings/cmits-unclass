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
# \subsection{Wrap 32-bit plugins}
#
# This defined resource type makes sure a 32-bit Mozilla plugin is wrapped on
# 64-bit hosts. 32-bit plugins that come from Red Hat (e.g.,
# \verb!flash-plugin!) will do this themselves, but plugins from other vendors
# may not.
#
# To use this resource type, first get the 32-bit plugin installed, under
# \verb!/usr/lib/mozilla/plugins!, the place for 32-bit browser plugins under
# Red Hat-family Linuxen. Then make a resource of this type, whose name is the
# name of the plugin file.
#
# Example:
# \begin{verbatim}
#     mozilla::wrap_32bit { 'npica.so': }
# \end{verbatim}
# \dinkus

define mozilla::wrap_32bit {
    require mozilla::wrap_32bit::prerequisites
    case $::osfamily {
        'RedHat': {
            $thirtytwo_dir = "/usr/lib/mozilla/plugins"
            $wrapped_dir   = "/usr/lib64/mozilla/plugins-wrapped"
            case $::architecture {
                'x86_64': {
                    exec { "wrap_32bit_${name}":
                        onlyif => "test -f ${thirtytwo_dir}/${name}",
                        command => "mozilla-plugin-config -i",
                        creates => "${wrapped_dir}/nswrapper_32_64.${name}",
                    }
                }
                'i386': {}
                default: { unimplemented() }
            }
        }
        default: { unimplemented() }
    }
}
