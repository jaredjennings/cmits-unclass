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
# \section{NFS version 3}
# Most NFS filesystems are mounted using the automounter; see
# \ref{define_automount::mount} and look in the Defined Resource Types index.
#
# To use NFSv3 we must do remote procedure calls (RPC). This requires a
# portmapper or binder; under RHEL5 this is called \verb!portmap! and under
# RHEL6 it is \verb!rpcbind!.
#
# There's also a statd and maybe a lockd which need to be installed and
# running, which are contacted via RPC.

class nfs {
# In \S\ref{module_gdm}, the pieces of policy for each OS and version are split
# out into separate files. Here they are all written in two big case
# statements. For further implementations, decide which is simpler and better.

    case $osfamily {
        RedHat: {
            $portmap = $operatingsystemrelease ? {
                /^6.*/ => "rpcbind",
                /^5.*/ => "portmap",
                default => unimplemented(),
            }
            package { $portmap: ensure => present }
            tcp_wrappers::allow { $portmap:
                from => "127.0.0.1",
            }
            service { $portmap:
                require => [
                    Package[$portmap],
                    Tcp_wrappers::Allow[$portmap],
                ],
                enable => true,
                ensure => running,
            }

            package { "nfs-utils":
                require => Package[$portmap],
                ensure => present,
            }
            service { "nfslock":
                require => [
                    Service[$portmap],
                    Package["nfs-utils"],
                ],
                enable => true,
                ensure => running,
            }
        }
# Mac OS X Snow Leopard is rather more monolithically installed, and comes with
# NFS support.
        darwin: {}
        default: { unimplemented() }
    }
}
