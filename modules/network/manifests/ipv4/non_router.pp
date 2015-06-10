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
# \subsubsection{IPv4 non-routers}

class network::ipv4::non_router {

    case $::osfamily {
        'redhat': {
# \implements{unixsrg}{GEN005600}%
# Turn off IPv4 forwarding for non-router Red Hat hosts.
            augeas { "no_ipv4_forwarding":
                context => "/files/etc/sysctl.conf",
                changes => "set net.ipv4.ip_forward 0",
            }
        }
        'darwin': {
# \implements{macosxstig}{GEN005600 M6}%
# \implements{mlionstig}{OSX8-00-01205}%
# Turn off IPv4 forwarding for non-router Macs.
            augeas { "no_ipv4_forwarding":
                context => "/files/etc/sysctl.conf",
                changes => "set net.inet.ip.forwarding 0",
            }
        }
        default:  { unimplemented() }
    }
}
