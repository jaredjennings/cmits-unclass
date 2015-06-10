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
# \subsection{STIG-required Samba configuration under Red Hat}

class samba::stig::redhat {

# \implements{unixsrg}{GEN006100,GEN006120,GEN006140}%
# Control ownership and permissions of \verb!smb.conf!. 
#
# Under RHEL, all Samba configuration goes under \verb!/etc/samba!, so we
# secure \verb!/etc/samba/smb.conf! not \verb!/etc/smb.conf!.
    file { "/etc/samba/smb.conf":
        owner => root, group => 0, mode => 0644,
    }

# \implements{unixsrg}{GEN006150}%
# Remove extended ACLs on \verb!smb.conf!.
    no_ext_acl { "/etc/samba/smb.conf": }

# \implements{unixsrg}{GEN006160,GEN006180,GEN006200}%
# Control ownership and permissions of \verb!smbpasswd!.
    file { "/etc/samba/smbpasswd":
        owner => root, group => 0, mode=> 0600,
    }

# \implements{unixsrg}{GEN006210}%
# Remove extended ACLs on \verb!smbpasswd!.
    no_ext_acl { "/etc/samba/smbpasswd": }

}
