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
# \section{Network}

class network {

# Support restarting the network: Other parts of the manifest have
# \verb!notify => Service["network"]!. That refers here.

    service { "network": }

# Anything interested in restarting the network is likely interested in knowing
# about which interfaces we're using on this host.

    include network::interfaces
}

# \bydefault{RHEL6}{unixsrg}{GEN007140,GEN007200,GEN007260,GEN007320,GEN007540,GEN007760}%
# RHEL6 does not appear to provide any packages or loadable kernel modules
# relating to the less-widely-used UDP-Lite, IPX, AppleTalk, DECnet, TIPC or
# NDP protocols.
#
# \bydefault{RHEL5, RHEL6}{unixsrg}{GEN007840}%
# RHEL does not run the DHCP client for any interfaces not configured for DHCP,
# i.e. where it is ``not needed.''
#
# The DHCP client is configured not to send dynamic DNS updates, surprisingly,
# in \S\ref{class_eue::dns}. \index{FIXME}
#
#
# \subsection{Admin guidance regarding networking}
#
# \doneby{admins}{unixsrg}{GEN007820}%
# Don't configure any IP tunnels.
#
