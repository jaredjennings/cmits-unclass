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
# \subsection{Lock down essential network analysis tools}
#
# For network tools that can't or shouldn't be removed, lock down access to
# them.

class network_tools::stig_essential {
# \implements{macosxstig}{GEN003960 M6,GEN003980 M6,GEN004000 M6}%
# \implements{unixsrg}{GEN003960,GEN003980,GEN004000}%
# Make the {\tt traceroute} utility executable only by root.
    $traceroute = $::osfamily ? {
# We'll throw in \verb!traceroute6! for free.
        'redhat' => [ '/bin/traceroute', '/bin/traceroute6' ],
        'darwin' => '/usr/sbin/traceroute',
        default  => unimplemented,
    }
    file { $traceroute:
        owner => root, group => 0, mode => 0700;
    }
# \implements{macosxstig}{GEN004010 M6}%
# \implements{unixsrg}{GEN004010}%
# Remove extended ACLs on the {\tt traceroute} executable.
    no_ext_acl { $traceroute: }
}
