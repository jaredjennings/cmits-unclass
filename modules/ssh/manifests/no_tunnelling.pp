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
# \subsection{Disable SSH tunnelling features}
#
# This is the subset of STIG-related SSH configuration that is odious.
class ssh::no_tunnelling {
    include ssh
    augeas { "sshd_no_tunnelling":
        context => "/files${ssh::server_config}",
        changes => [
# \implements{unixsrg}{GEN005515} Disallow TCP connection forwarding over SSH,
# because of the ``risk of providing a path to circumvent firewalls and network
# ACLs.''
#
# Note that under the SRG this can be allowed if mitigated. (The sshd\_config
# man page says, ``Note that disabling TCP forwarding does not improve security
# unless users are also denied shell access, as they can always install their
# own forwarders.'' No reply to that from the SRG.)
            "set AllowTcpForwarding no",
# \implements{unixsrg}{GEN005517} Disallow gateway ports.
            "set GatewayPorts no",
# \implements{unixsrg}{GEN005519} Disallow X11 forwarding.
#
# This can also be allowed if mitigated.
            "set X11Forwarding no",
# \implements{unixsrg}{GEN005531} Disallow \verb!tun(4)! device forwarding.
#
# (Wow, I didn't know sshd could do that. Quite cool... except now it's
# disabled.)
            "set PermitTunnel no",
        ],
        notify => Service["sshd"],
    }

# \implements{unixsrg}{GEN005533} Limit connections to a single session.
#
# Lower the session limit per connection. A terminal uses a session,
# and so does a forwarded port or X11 connection. But RHEL5 ssh
# doesn't understand this directive.
    case $::osfamily {
        'RedHat': {
            case $::operatingsystemrelease {
                /^6\./: {
                    augeas { 'sshd_yes_tunnelling_max_sessions':
                        context => "/files${ssh::server_config}",
                        changes => 'set MaxSessions 1',
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
    include augeas

    augeas { "ssh_client_no_tunnelling":
        context => "/files${ssh::server_config}/Host[.='*']",
        changes => [
# \implements{unixsrg}{GEN005516} Disallow TCP forwarding in the client. (See
# above.)
            "set ClearAllForwardings yes",
# \implements{unixsrg}{GEN005518} Disallow gateway ports.
            "set GatewayPorts no",
# \implements{unixsrg}{GEN005520} Disallow X11 forwarding. See above.
            "set ForwardX11 no",
            "set ForwardX11Trusted no",
# \implements{unixsrg}{GEN005532} Disallow \verb!tun(4)! device forwarding.
            "set Tunnel no",
        ],
    }
}
