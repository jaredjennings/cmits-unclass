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
class hpc_cluster::login_node::proxy(
    $internal_ipv4_subnet) {

# Make HTTP and HTTPS available on the internal network.
    package { 'squid':
        ensure => installed,
    }
    augeas { 'squid for cluster login':
        context => '/files/etc/squid/squid.conf',
        changes => [
            'rm acl[localnet][position() > 1]',
            'set acl[localnet][1]/localnet/type src',
            "set acl[localnet][1]/localnet/setting \
             '${internal_ipv4_subnet}'",
        ],
        require => Package['squid'],
        notify => Service['squid'],
    }
    augeas { 'let cluster nodes use Puppet port':
        context => '/files/etc/squid/squid.conf',
        changes => [
            'defnode puppet_port acl[999] ""',
            'set $puppet_port/SSL_ports/type port',
            'set $puppet_port/SSL_ports/setting 8140',
            ],
        onlyif => "match acl[SSL_ports/type='port' and \
                             SSL_ports/setting='8140'] \
                   size == 0",
    }
    service { 'squid':
        enable => true,
        ensure => running,
    }
}
