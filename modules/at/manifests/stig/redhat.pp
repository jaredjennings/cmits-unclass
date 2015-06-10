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
# \subsection{STIG-required at subsystem configuration for RHEL}
#
# Under RHEL and derivatives, only allow root to do at jobs.

class at::stig::redhat {
    file {
# \implements{unixsrg}{GEN003252,GEN003300,GEN003480,GEN003490}%
# Remove \verb!at.deny!, in order to specify
# access by who is allowed, not by who is denied.
        "/etc/at.deny":
            ensure => absent;
# \implements{unixsrg}{GEN003280,GEN003320,GEN003460,GEN003470,GEN003340}%
# Control contents and permissions of \verb!at.allow!.
        "/etc/at.allow":
            owner => root, group => 0, mode => 0600,
            content => "root\n";
# \implements{unixsrg}{GEN003400,GEN003420,GEN003430}%
# Control permissions of ``the `at' directory.''
#
# In the default install, this is owned by \verb!daemon!, group \verb!daemon!,
# so this change might break \verb!at!. 
        "/var/spool/at":
            owner => root, group => 0, mode => 0700;
    }

    no_ext_acl {
# \implements{unixsrg}{GEN003245}%
# Remove extended ACL on \verb!at.allow!.
        "/etc/at.allow":;
# \implements{unixsrg}{GEN003255}%
# Remove extended ACL on \verb!at.deny!.
        "/etc/at.deny":;
# \implements{unixsrg}{GEN003410}%
# Remove extended ACLs in ``the `at' directory.''
        "/var/spool/at": recurse => true;
    }
}
#

