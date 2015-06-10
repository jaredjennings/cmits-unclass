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
# \subsection{STIG-required network configuration}

class network::stig {
# \subsubsection{Common implementations of compliance}
#
# \implements{macosxstig}{GEN003760 M6,GEN003770 M6,GEN003780 M6}%
# \implements{unixsrg}{GEN003760,GEN003770,GEN003780}%
# Control ownership and permissions of the \verb!services! file.
    file { "/etc/services":
        owner => root, group => 0, mode => 0644,
    }
# \implements{unixsrg}{GEN003790}%
# Remove extended ACLs on the \verb!services!  file.
    no_ext_acl { "/etc/services": }

# \subsubsection{Platform-specific implementations of compliance}
    case $::osfamily {
        'RedHat': { include network::stig::redhat }
        'Darwin': { include network::stig::darwin }
        default:  { unimplemented() }
    }
}
