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
# \subsection{All internal nodes}
#
# Any node inside the cluster needs these resources. With cluster
# management software, perhaps only the management nodes will run
# Puppet, and will cause the compute nodes to fall in line by other
# means than Puppet.

class hpc_cluster::node($cluster_hostname) {
    Proxy::Yum <<| name == "${cluster_hostname}" |>>
    Augeas <<| name == "${cluster_hostname} dns" |>>
    Augeas <<| name == "${cluster_hostname} gateway" |>>
    Smtp::Use_smarthost <<| tag == $cluster_hostname |>>
    include ::ntp
    Augeas <<| name == "${cluster_hostname} ntp.conf" |>>

    package { [
            'lynx',
            'man',
            'vim-enhanced',
            'wget',
            'bind-utils',
            'ipmitool',
# panfs install uses bc.
            'bc',
# Infiniband.
            'opensm',
            'ibutils',
            'rdma',
            'libibverbs-utils',
            'infiniband-diags',
        ]:
            ensure => installed,
    }

    service {
        'rdma':
            enable => true,
            ensure => running;
        'opensm':
            enable => true,
            ensure => running;
    }

# This is so when people \verb!module add openmpi!, they will get the
# PGI version by default, from among the \verb!openmpi!s that Scyld
# has built.
    file { '/opt/scyld/modulefiles/openmpi/.modulerc':
        ensure => present,
        owner => root, group => 0, mode => 0644,
        content => "#%Module
module-version pgi default
",
    }

}
