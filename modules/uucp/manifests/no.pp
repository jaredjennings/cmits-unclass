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
# \subsection{Turn off UUCP}
#
# \unixsrg{GEN005280} requires that UUCP be disabled.

class uucp::no {
    case $::osfamily {
        'redhat': {
            case $::operatingsystemrelease {
# \bydefault{RHEL6}{unixsrg}{GEN005280} RHEL6 does not provide a UUCP service.
                /^6\..*$/: {}
                /^5\..*$/: { package { 'uucp': ensure => absent, } }
            }
        }
# \implements{macosxstig}{GEN005280 M6}%
# \implements{mlionstig}{OSX8-00-00550}%
# Make sure that the UUCP service is disabled.
        'darwin': {
            service { 'com.apple.uucp':
                enable => false,
                ensure => stopped,
            }
        }
        default: { unimplemented() }
    }
}
