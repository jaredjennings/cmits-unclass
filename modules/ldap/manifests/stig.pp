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
# \subsection{STIG-required LDAP configuration}

class ldap::stig {

# \implements{macosxstig}{GEN008060 M6,GEN008080 M6,GEN008100 M6}%
# \implements{unixsrg}{GEN008060,GEN008080,GEN008100}%
# Control ownership and permissions of \verb!ldap.conf!.
    $ldap_conf = $::osfamily ? {
        'redhat' => '/etc/ldap.conf',
        'darwin' => '/etc/openldap/ldap.conf',
        default  => unimplemented,
    }
    file { $ldap_conf:
        owner => root, group => 0, mode => 0644,
    }

# \implements{macosxstig}{GEN008120 M6}%
# \implements{unixsrg}{GEN008120}%
# Remove extended ACLs on \verb!ldap.conf!.
    no_ext_acl { $ldap_conf: }

# \notapplicable{unixsrg}{GEN008140,GEN008160,GEN008180,GEN008200}%
# \notapplicable{unixsrg}{GEN008220,GEN008240,GEN008260,GEN008280}%
# \notapplicable{unixsrg}{GEN008300,GEN008320,GEN008340,GEN008360}%
# This policy presently does not configure an LDAP client.

}
