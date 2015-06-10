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
# \section{ip6tables}
#
# \verb!ip6tables! is the IPv6 packet filter under Linux.
#
# \implements{unixsrg}{GEN008520} Employ a local firewall for IPv6, using
# \verb!ip6tables!.
#
# \verb!ip6tables! rules are constructed in this policy from
# templates. This lets us group related rules, and include them as a
# whole; it makes explicit the order of the rules, which is quite
# important; and it lets us have both sets of rules general to a whole
# class of host (\emph{e.g.} workstations) and sets of rules specific
# to a single host (\emph{e.g.} \verb!sumo!).
#
class ip6tables {
    package { 'iptables-ipv6': 
        ensure => present,
    }
    service { 'ip6tables':
        ensure => running,
        hasstatus => true,
    }
}

# The actual firewall rules that implement the following requirements are in
# the templates for this module, not here; but here is the place where they can
# be indexed, summarized and prose written about them, so here they are
# documented.
#
# \implements{unixsrg}{GEN003605,GEN003606} Configure the local firewall to
# reject all source-routed IPv6 packets, even those generated locally.
#
# Source routing in IPv6 is done with Routing Header 0 (RH0); we merely need to
# drop every packet that has that optional header.
#
# \implements{unixsrg}{GEN008540} Configure the local firewall to reject all
# IPv6 packets by default, allowing only by exception.
#
# \implements{unixsrg}{GEN003602,GEN003604} Configure the local firewall to
# reject ICMPv6 timestamp requests, including those sent to a broadcast address.
