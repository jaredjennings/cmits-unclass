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
# \section{Managing GPG keys in the RPM database}
#
# This defined resource type can manage GPG keys used to sign RPM
# packages.
#
# Example:
# \begin{verbatim}
# rpm::gpgkey { 'd3adb33f': source => 'http://myserver/pub/d3adb33f.key' }
# \end{verbatim}
#
# The name should be an eight-digit hexadecimal number, the key
# identifier; the source can be anything that \verb!rpm --import!
# understands, like an http URL, or an absolute path to a file that
# exists and contains the GPG public key. For the optional ensure
# parameter you can give values `present' or `absent'; it defaults to
# `present'.

define rpm::gpgkey($source, $ensure='present') {
    case $ensure {
        'present': {
            exec { "import rpm gpg key ${name}":
                command => "rpm --import ${source}",
                unless => "rpm -q gpg-pubkey-${name}",
            }
        }
        'absent': {
            exec { "remove rpm gpg key ${name}":
                command => "rpm -e gpg-pubkey-${name}",
                onlyif => "rpm -q gpg-pubkey-${name}",
            }
        }
    }
}
