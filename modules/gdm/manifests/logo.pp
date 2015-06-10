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
# \subsection{Login prompt logos}
#
# Configure GDM to show an organization's logo at the login prompt.
#
# The \verb!source! parameter is used to fetch the image files for the logo. It
# specifies a Puppet module and directory inside which image files for the logo
# can be found. As an example, if you write
# \begin{verbatim}
#   class { 'gdm::logo':
#       source => 'puppet:///modules/gdm/logo/afseo',
#   }
# \end{verbatim}
# then files will be copied from \verb!puppet:///modules/gdm/logo/afseo! to
# places under \verb!/usr/share/icons!. The files placed in the manifest should
# go in the \verb!gdm/files/logo/afseo! directory. Inside that directory there
# should be a \verb!logo-48x48.png! file and a \verb!logo-scalable.png! file.
#
# For more details and explanation, consult the governing standards:
# \href{Installing
# Icons}{http://developer.gnome.org/integration-guide/stable/icons.html.en},
# \href{freedesktop.org Icon Naming
# Spec}{http://standards.freedesktop.org/icon-naming-spec/latest/}, and
# \href{freedesktop.org Icon Theme
# Spec}{http://standards.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html}.

class gdm::logo($source) {
    if($gdm_installed == 'true') {
        case $osfamily {
            RedHat: {
                case $operatingsystemrelease {
                    /^6\..*/: {
                        class { 'gdm::logo::rhel6':
                            source => $source,
                        }
                    }
                    /^5\..*/: {
                        class { 'gdm::logo::rhel5':
                            source => $source,
                        }
                    }
                    default: { unimplemented() }
                }
            }
            default: { unimplemented() }
        }
    }
}
