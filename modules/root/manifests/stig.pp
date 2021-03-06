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
# \subsection{STIG-required configuration regarding the root user}
#
# Parameter \verb!bashrc_variant! lets you choose what bashrc to use
# for root. This is needed because on most hosts it's necessary to
# find out which person is using a shared authenticator (i.e., the
# root account) and why, but on some hosts (e.g. Vagrant boxes) it's
# necessary to support automated root logins, without questions. In
# this case, give \verb!'no_questions'! as the value of this
# parameter.

class root::stig($bashrc_variant='default') {
# Make sure root can only login where root should.
    include root::login

# Make sure augeas is installed, so we can run \verb!augtool!.
    include augeas

# Make sure only root has a UID of 0.
    include root::only_uid_0

# \implements{unixsrg}{GEN000900}%
# Make sure the root user's home directory is not \verb!/!.
#
# We have a custom fact for root's home because we'll need it a bit farther down.
    case $::root_home {
        '/': {
            err("Root's home is /!")
        }
        '': {
            warning("Don't know root's home")
            file { "/root":
                owner => root,
                group => 0,
                mode => 0700,
            }
            no_ext_acl { "/root": }
        }
        default: {
# \implements{unixsrg}{GEN000920}%
# Secure ownership and permissions of root's home directory.
#
# We only want to do this if root's home is not \verb!/!.
            file { "$::root_home":
                owner => root,
                group => 0,
                mode => 0700,
            }
# \implements{unixsrg}{GEN000930}%
# Remove extended ACLs from root's home directory.
            no_ext_acl { "$::root_home": }
        }
    }


# Make sure root uses bash, so that root's \verb!.bashrc! will happen when
# someone becomes root. If the same code in the bashrc were ported to csh, we
# would not need to force root to use bash; but bash for root is already a
# vendor default.
#
# \doneby{admins}{unixsrg}{GEN001080}%
# Do not change this policy in a manner to cause root to use a shell not
# located on the root (/) filesystem.
    augeas { "root_use_bash":
        context => "/files/etc/passwd/*[name='root']",
        changes => "set shell /bin/bash",
    }

# \implements{unixsrg}{GEN000940,GEN000945,GEN000950,GEN000960}%
# Make sure that root's \verb!PATH!,
# \verb!LD_LIBRARY_PATH!, and \verb!LD_PRELOAD! environment variables are
# secure, and that no world-writable directories are on root's \verb!PATH!.
    file { "${::root_home}/.bashrc":
        owner => root, group => 0, mode => 0640,
        source => "puppet:///modules/root/bashrc.${bashrc_variant}",
    }

    include "root::stig::${::osfamily}"
}
