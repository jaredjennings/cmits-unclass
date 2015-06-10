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
# \subsection{Disable SCTP}
#
# \implements{unixsrg}{GEN007020} Disable the Stream Control Transmission
# Protocol (SCTP) ``unless required.'' We do not need it.
class network::no_sctp {
    package {
        "lksctp-tools": ensure => absent;
        "lksctp-tools-debuginfo": ensure => absent;
        "lksctp-tools-devel": ensure => absent;
        "lksctp-tools-doc": ensure => absent;
    }
    kernel_module { "sctp": ensure => absent }
# ``Unprivileged local processes may be able to cause the system to dynamically
# load a protocol handler by opening a socket using the protocol.'' (SRG
# discussion) Prevent this by removing related kernel module files.
    file {
        "/lib/modules/$kernelrelease/kernel/net/sctp":
            ensure => absent,
            recurse => true,
            recurselimit => 1,
            force => true,
    }
}
