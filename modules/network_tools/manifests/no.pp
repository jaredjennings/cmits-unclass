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
# \subsection{Remove network analysis tools}
#
# \implements{unixsrg}{GEN003865} Remove tools used for packet capture and
# analysis.
class stig_misc::network_tools {
    package {
        "iptraf": ensure => absent;
        "mtr-gtk": ensure => absent;
        "mtr": ensure => absent, require => Package['mtr-gtk'];
        "nmap": ensure => absent;
        "wireshark-gnome": ensure => absent;
        "wireshark": ensure => absent, require => Package['wireshark-gnome'];
# This one may be innocuous---but once I had it installed and it made a log
# message about root logging in, \emph{every five seconds}. Kill it with fire!
        "mrtg": ensure => absent;
        "tcpdump": ensure => absent;
    }

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
