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
# \section{iptables}
#
# \implements{unixsrg}{GEN008520} Employ a local firewall, using
# \verb!iptables!.
#
# \verb!iptables! rules are constructed in this policy from
# templates. This lets us group related rules, and include them as a
# whole; it makes explicit the order of the rules, which is quite
# important; and it lets us have both sets of rules general to a whole
# class of host (\emph{e.g.} workstations) and sets of rules specific
# to a single host (\emph{e.g.} \verb!sumo!).
#
class iptables {
    service { "iptables":
        ensure => running,
        hasstatus => true,
    }
# \unimplemented{unixsrg}{GEN003600,GEN003605,GEN003606}{The
# requirement is to drop source-routed IPv4 packets. At SEARDE
# production go-time, the {\tt xtables-addons} package, which
# supplies the iptables match code for IPv4 options, including source
# routing, wasn't working with the rest of iptables. That means
# source-routed packets are not being specifically dropped at the host
# firewall. See~\S\ref{class_network::stig} for another way that most
# of the source-routed traffic is being rejected.}
#
# Our previous means of compliance here has been deleted; see previous
# versions of this file in Subversion.
}

# \implements{unixsrg}{GEN008540} Configure the local firewall to reject all
# packets by default, allowing only by exception.
#
# \implements{unixsrg}{GEN003602,GEN003604} Configure the local firewall to
# reject ICMP timestamp requests, including those sent to a broadcast address.
