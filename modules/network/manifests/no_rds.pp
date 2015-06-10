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
# \subsection{Disable RDS}
#
# \implements{unixsrg}{GEN007480} Disable and/or uninstall the Reliable Datagram
# Sockets (RDS) protocol ``unless required.''
class network::no_rds {
    package {
        "rds-tools": ensure => absent;
        "rds-tools-debuginfo": ensure => absent;
    }
    kernel_module {
        "rds": ensure => absent;
        "rds_rdma": ensure => absent;
        "rds_tcp": ensure => absent;
    }
# ``Unprivileged local processes may be able to cause the system to dynamically
# load a protocol handler by opening a socket using the protocol.'' (SRG
# discussion) Prevent this by removing related kernel module files.
    file {
        "/lib/modules/$kernelrelease/kernel/net/rds":
            ensure => absent,
            recurse => true,
            recurselimit => 1,
            force => true,
    }
}
