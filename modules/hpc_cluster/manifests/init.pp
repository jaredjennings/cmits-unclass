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
# \section{HPC Clustering}
#
# Configure HPC clusters with login nodes on the production network,
# and management nodes behind the login nodes, in a particular style.
#
# Besides offering users on the production network access to the cluster, the
# login node also forwards the services of the production network inside the
# cluster network, so that security updates, policy enforcement, and unified
# authentication and authorization can happen without the cluster management
# software being exposed on the production network.
#
# We assume here that the cluster's internal network has a subnet
# \verb!X.Y.0.0/16!. We give the cluster's internal network a DNS subdomain
# named for the cluster's login node(s); this subdomain is visible only inside
# the cluster. Inside that network and DNS subdomain, we have the following
# common subnets, addresses and hostnames:
#
# \begin{itemize}
# \item Subnet 0: management
#   \begin{itemize}
#   \item X.Y.0.1: \verb!head!, the IP address belonging to whichever head is
#   active among the redundant head nodes
#   \item X.Y.0.2: \verb!head1!, the first head node
#   \item X.Y.0.3: \verb!head2!, the second head node (and so on)
#   \end{itemize}
# \item Subnet 1: login nodes
#   \begin{itemize}
#   \item X.Y.1.1: \verb!login!, the internal IP address beloging to whichever
#   login node is active among the redundant login nodes
#   \item X.Y.1.2: \verb!login1!, the internal IP address of the first login
#   node
#   \item X.Y.1.3: \verb!login2!, the internal IP address of the second login
#   node (and so on)
#   \end{itemize}
# \item Subnet 50 (and beyond, if needed): compute nodes
# \end{itemize}
#
# Furthermore, we assume another subnet \verb!X.Z.0.0/16!, where $Z$
# is usually $Y + 1$, used for Infiniband.
#
# Settings on the outside of the cluster are not set here. For example, if you
# have a cluster with two login nodes known on the production network as
# \verb!fnord1! and \verb!fnord2!, you'll need to set up DNS for each of these
# outside this class, as well as whatever mechanism makes it possible for them
# all to show up as host \verb!fnord!, and users who attempt access to be
# shunted to one login node or another.
