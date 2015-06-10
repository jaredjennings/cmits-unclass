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
# \subsection{Solitary login node}
#
# This is just like \verb!login_node! but is used in the case where the login
# node is not redundant.

class hpc_cluster::solitary_login_node(
        $internal_ipv4_first_two_octets,
        $internal_infiniband_ipv4_first_two_octets,
        $external_interface = 'eth0',
        $internal_interface = 'eth1',
        $compute_node_count,
        $use_infiniband='false',
        ) {

    $iifto = $internal_ipv4_first_two_octets
    $login_internal_ipv4 = "${iifto}.1.1"
    $login1_internal_ipv4 = "${iifto}.1.2"
    $iibifto = $internal_infiniband_ipv4_first_two_octets
    $login1_internal_infiniband_ipv4 = "${iibifto}.1.2"

    class { 'hpc_cluster::login_node':
        internal_ipv4_first_two_octets =>
                $internal_ipv4_first_two_octets,
        internal_infiniband_ipv4_first_two_octets =>
                $internal_infiniband_ipv4_first_two_octets,
        internal_ipv4_address =>
                $login1_internal_ipv4,
        internal_infiniband_ipv4_address =>
                $login1_internal_infiniband_ipv4,
        compute_node_count =>
                $compute_node_count,
        use_infiniband => $use_infiniband,
        internal_interface => $internal_interface,
        external_interface => $external_interface,
    }

# Configure the alias on the internal network interface. Redundant
# login nodes will have heartbeat configuration to pass this IP
# address between themselves on failure, but solitary login nodes will
# just always hold the alias.
    $augeas_ifcfg = '/files/etc/sysconfig/network-scripts/ifcfg'
    augeas { "${hostname} ${cluster_hostname} internal solitary":
        context => "${augeas_ifcfg}-${internal_interface}",
        changes => [
            "set IPADDR2 ${login_internal_ipv4}",
            'set NETMASK2 255.255.0.0',
        ],
    }
}
