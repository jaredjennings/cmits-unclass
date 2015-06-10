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
# \subsection{Remove rpcbind}
#
# \implements{unixsrg}{GEN003810,GEN003815} Remove the rpcbind or portmap
# service wherever it is not necessary (it is necessary where NFS is in use).

class nfs::client::no::redhat {
    case $operatingsystemrelease {
        /6\..*/: {
# We have to do this using an exec because the package type can only
# remove one package at a time, but nfs-utils and nfs-utils-lib each
# depend on the other, so neither can be successfully removed by
# itself. See \url{http://projects.puppetlabs.com/issues/2198}.
            exec { 'remove NFS client packages':
                command => "/usr/bin/yum -y remove \
                rpcbind \
                nfs-utils \
                nfs-utils-lib",
                onlyif => "/bin/rpm -q \
                rpcbind \
                nfs-utils \
                nfs-utils-lib",
            }
        }
        /5\..*/: {
            package {
                "portmap": ensure => absent;
                "ypbind": ensure => absent;
                "nfs-utils": ensure => absent;
            }
        }
        default: { unimplemented() }
    }
}
