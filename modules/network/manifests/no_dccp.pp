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
# \subsection{Disable DCCP}
#
# \implements{unixsrg}{GEN007080} Disable the Datagram Congestion Control
# Protocol (DCCP) ``unless required.'' We do not need it.
class network::no_dccp {
    kernel_module {
        "dccp_diag": ensure => absent;
        "dccp_ipv4": ensure => absent;
        "dccp_ipv6": ensure => absent;
        "dccp_probe": ensure => absent;
        "dccp": ensure => absent;
    }
# ``Unprivileged local processes may be able to cause the system to dynamically
# load a protocol handler by opening a socket using the protocol.'' (SRG
# discussion) Prevent this by removing related kernel module files.
    file {
        "/lib/modules/$kernelrelease/kernel/net/dccp":
            ensure => absent,
            recurse => true,
            recurselimit => 1,
            force => true,
    }
}
