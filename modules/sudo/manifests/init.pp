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
# \section{sudo}
#
# The parts of this module you want to use are \verb!sudo::allow_user!
# and \verb!sudo::allow_group!. See them below. Everything else is
# machinery to make them happen portably.

class sudo(
    $sudoers=$sudo::params::sudoers,
    $sudoers_d=$sudo::params::sudoers_d)
inherits sudo::params {

# As much as possible, we are writing each piece of sudo configuration
# in its own file. We place these files in the \verb!$sudoers_d!.
    file { $sudoers_d:
        ensure => directory,
        owner => root, group => 0, mode => 0750,
    }

    case $::osfamily {
# RHEL5 and RHEL6 both have sudo newer than 1.7.1, which is when the
# \verb!#includedir! directive was added. In these cases we can just
# \verb!#includedir! our \verb!sudoers.d! directory.
        'RedHat': {
            augeas { 'consult_sudoers_d':
                context => "/files${sudoers}",
                incl => $sudoers,
                lens => "Sudoers.lns",
                changes => "set '#includedir' '${sudoers_d}'",
            }
        }
# We deal with Snow Leopard in \verb!sudo::policy_file!.
        'Darwin': {}
        default: { unimplemented() }
    }
}
