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
# \subsection{Management nodes}
#
# These are the nodes that head up the cluster: running the cluster
# management and queueing system software.

class hpc_cluster::management_node($cluster_hostname) {
  class { 'hpc_cluster::node':
      cluster_hostname => $cluster_hostname,
  }
  Automount::Mount <<| tag == "${cluster_hostname}_passwd" |>>
  # Get user and group information from the login node and write it in
  # my passwd and group files.
  file { '/etc/cron.hourly/hpc_cluster_passwd_group':
      owner => root, group => 0, mode => 0755,
      source => "puppet:///hpc_cluster/integrate.cron",
  }
# At present there is no puppet on management nodes. Besides the
# preceding, to get a management node up you must do the following:
#
# \begin{enumerate}
# \item Add the ClusterWare yum repo. (The exact URL depends on the cluster ID.)
# \item Install ClusterWare: \verb!yum groupinstall Scyld-ClusterWare!.
# \item Configure (\verb!/etc/beowulf/config!).
# \item Obtain the DirectFLOW RPM from Panasas that corresponds to the ClusterWare kernel you're running.
# \item Verify internal filer connectivity; set up NFS and Panasas mounts, on management and compute nodes.
# \item Choose a place where the SGE\_ROOT will go.
# \item Build and install GridEngine.
# \item Write modulefiles for GridEngine for the login and management nodes.
# \item chkconfig GridEngine on.
# \item Make sure the management node has /etc/modulefiles on the MODULEPATH.
# \item Make sure the management node's internal IP reverse-looks-up to headX.CLUSTER.FQDN.
# \item Install Scyld OpenMPI packages on login nodes.
# \item Configure HA.
# \item Prestage \verb!/etc/profile.d/before_modules.sh! in the /etc/beowulf/config so the MODULEPATH will be right on the compute nodes.
# \item Install valgrind.
# \item Export /usr/bin, /usr/sbin, /usr/share from the management node to the cluster network.
# \item Configure the compute nodes to mount these filesystems.
# \item Adapt the Scyld /etc/beowulf/init.d/sshd script to merely configure sshd, not run it.
# \item Configure GridEngine to use ssh for its rsh/rlogin, so that interactive jobs can be run with X forwarding.
# \end{enumerate}
}
