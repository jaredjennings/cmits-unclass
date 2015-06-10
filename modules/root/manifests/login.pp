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
# \subsection{Where root can log in}
#
# \implements{unixsrg}{GEN000980,GEN001020} Make sure root can only log in from
# the console.
#
# ``Console'' means any tty listed in \verb!/etc/securetty!. It's likely that
# some setting in \verb!/etc/login.defs! could be set to ensure this property;
# but we can be more general by using PAM to enforce it instead.
class root::login {
    case $::osfamily {
        'RedHat': {
            include pam::securetty

# Make sure the \verb!/etc/securetty! file contains exactly what it should.
#
# \implements{rhel5stig}{GEN000000-LNX00620,GEN000000-LNX00640,GEN000000-LNX00660}%
# Control ownership and permissions on the \verb!securetty! file.
            file { "/etc/securetty":
                owner => root, group => 0, mode => 0600,
                source => "puppet:///modules/root/login/securetty",
            }
# Interestingly, there appears to be no STIG requirement to remove extended
# ACLs from this file. But we do it anyway.
            no_ext_acl { "/etc/securetty": }
        }
# Mac OS X doesn't support root logins at all by default.
        'Darwin': {}
        default: { unimplemented() }
    }
}
