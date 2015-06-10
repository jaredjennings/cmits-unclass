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
# \subsubsection{Disable rsh, rlogin, and rexec under Red Hat}

class rsh::no::redhat {
# \implements{unixsrg}{GEN003820,GEN003825,GEN003830,GEN003835,GEN003840,GEN003845}%
# Under RHEL, to ensure that rsh and rlogin are disabled, uninstall them.
#
# (Under RHEL, \verb!rsh!, \verb!rlogin!, \verb!rexec! and \verb!rcp! and their
# respective servers all come in two packages.)
    package {
        "rsh": ensure => absent;
        "rsh-server": ensure => absent;
    }
}
