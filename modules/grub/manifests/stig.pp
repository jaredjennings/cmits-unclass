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
# \subsection{STIG-required configuration}

class grub::stig {
# \implements{rhel5stig}{GEN000000-LNX00720} Turn on auditing in time to audit the
# actions of startup scripts.
    $g = "/boot/grub/grub.conf"
    exec { "auditify_kernel_cmdlines":
        path => "/bin:/sbin",
        onlyif => "grep '^[[:space:]]*kernel' $g | \
                   grep -v audit=1 >&/dev/null",
        command => "sed -i.audit -e \
            '/[[:space:]]*kernel/s/\$/ audit=1/' $g",
        logoutput => true,
    }
# \doneby{admins}{unixsrg}{GEN008720,GEN008740,GEN008760,GEN008780}%
# Make sure the configuration file \verb!/boot/grub/menu.lst! is owned
# by root, group-owned by root, has permissions \verb!0600!, and has no
# extended ACL.
    file { $g:
        owner => root, group => 0, mode => 0600,
    }
    no_ext_acl { $g: }
}
