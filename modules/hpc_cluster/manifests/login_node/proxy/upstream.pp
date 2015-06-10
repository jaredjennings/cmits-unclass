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
# Use this class when the proxy that the login node offers to the HPC
# cluster internal network should in turn use a proxy to access the
# Net.

class hpc_cluster::login_node::proxy::upstream(
    $host,
    $port,
    $dontproxy_domain)
{
    include hpc_cluster::login_node::proxy

    augeas { 'squid upstream proxy for cluster login':
        context => '/files/etc/squid/squid.conf',
        changes => [
            'rm acl[dontproxy_dns][position() > 1]',
            'set acl[dontproxy_dns]/dontproxy_dns/type dstdomain',
            "set acl[dontproxy_dns]/dontproxy_dns/setting \
             ${dontproxy_domain}",
            'rm acl[dontproxy_ip][position() > 1]',
            'set acl[dontproxy_ip]/dontproxy_ip/type dst',
            "set acl[dontproxy_ip]/dontproxy_ip/setting \
             ${hpc_cluster::login_node::proxy::internal_ipv4_subnet}",
            "set cache_peer \
             '${host} parent ${port} 0 no-query default'",
            "set cache_peer_access \
             '${host} deny dontproxy_dns dontproxy_ip'",
            'rm acl[localnet][position() > 1]',
            'set acl[localnet][1]/localnet/type src',
            "set acl[localnet][1]/localnet/setting \
             '${internal_ipv4_subnet}'",
        ],
        require => Package['squid'],
        notify => Service['squid'],
    }
}

