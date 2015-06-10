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
# \subsection{Disable CUPS}
#
# \implements{unixsrg}{GEN003900}%
# On hosts which do not need to print, disable CUPS entirely. This trivially
# complies with this requirement not to ``allow all hosts to use local print
# resources.''
#

class cups::no {

# \implements{unixsrg}{GEN003920,GEN003930,GEN003940,GEN003950}%
# Remove CUPS and the ``hosts.lpd (or equivalent) file,'' which in the case of
# CUPS is \verb!/etc/cups/cupsd.conf!. This trivially prevents ``unauthorized
# modifications'' or ``unauthorized remote access.''

    include "cups::no::${::osfamily}"
    file { '/etc/cups/cupsd.conf':
        ensure => absent,
    }
}
