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
# \subsection{Enable useful SSH features}
#
# If we wanted to enable useful SSH features, this is how we would do it.

class ssh::tunnelling {
    include ssh
    augeas { "sshd_yes_tunnelling":
        context => "/files${ssh::server_config}",
        changes => [
            "set AllowTcpForwarding yes",
# Still disallow gateway ports.
            "set GatewayPorts no",
# Allow X11 forwarding. \unixsrg{GEN005519} suggests that restrictions be
# placed on which users can use this feature in order to mitigate the risk of
# enabling it.
            "set X11Forwarding yes",
# Still disallow \verb!tun(4)! device forwarding. We don't need it.
            "set PermitTunnel no",
        ],
        notify => Service["sshd"],
    }

# Raise the session limit per connection. A terminal uses a session,
# and so does a forwarded port or X11 connection. But RHEL5 ssh
# doesn't understand this directive.
    case $::osfamily {
        'RedHat': {
            case $::operatingsystemrelease {
                /^6\./: {
                    augeas { 'sshd_yes_tunnelling_max_sessions':
                        context => "/files${ssh::server_config}",
                        changes => 'set MaxSessions 10',
                        notify => Service['sshd'],
                    }
                }
                /^5\./: {
                    augeas { 'sshd_yes_tunnelling_max_sessions':
                        context => "/files${ssh::server_config}",
                        changes => 'rm MaxSessions',
                        notify => Service['sshd'],
                    }
                }
                default: {}
            }
        }
        default: {}
    }

# The \verb!/etc/ssh/ssh_config! file is parsed by a non-stock lens.
    require augeas

    augeas { "ssh_client_no_tunnelling":
        context => "/files${ssh::client_config}/Host[.='*']",
        changes => [
# Allow TCP forwarding in the client.
            "set ClearAllForwardings no",
# Still disallow gateway ports.
            "set GatewayPorts no",
# Allow X11 forwarding. Trusted is riskier and we don't need it.
            "set ForwardX11 yes",
            "set ForwardX11Trusted no",
# Still disallow \verb!tun(4)! device forwarding.
            "set Tunnel no",
        ],
    }
}
