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
# \subsubsection{IPv6 non-routers}

class network::ipv6::non_router {

    case $::osfamily {
        'redhat': {
# \implements{unixsrg}{GEN005590} Remove IPv6 routing protocol daemons from
# non-routing systems.
            package {
                "quagga": ensure => absent;
                "radvd": ensure => absent;
            }
# \implements{unixsrg}{GEN005610} Turn off IPv6 forwarding for
# non-routers.
            augeas { "no_ipv6_forwarding":
                context => "/files/etc/sysctl.conf",
                changes => "set ipv6.conf.all.forwarding 0",
            }
        }
        'darwin': {
# The Mac OS X STIG appears to have no requirements for us to do anything here.
        }
        default:  { unimplemented() }
    }
}

