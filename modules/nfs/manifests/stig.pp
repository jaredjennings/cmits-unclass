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
# \subsection{STIG-required NFS configuration}
class nfs::stig {
    include nfs
# \implements{unixsrg}{GEN005740,GEN005750,GEN005760}%
# Control ownership and permissions of the \verb!exports! file.
    file { "/etc/exports":
        owner => root, group => 0, mode => 0644,
    }
# \implements{unixsrg}{GEN005770}%
# Remove extended ACLs on the \verb!exports!  file.
    no_ext_acl { "/etc/exports": }
# \implements{rhel5stig}{GEN000000-LNX00560}%
# Remove the insecure\_locks export option wherever it exists.
    augeas { 'remove_insecure_locks_in_exports':
        context => '/files/etc/exports',
        changes => 'rm dir/client/option[.="insecure_locks"]',
    }
}
