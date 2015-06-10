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
# \section{Miscellaneous STIG requirements}
#
# STIG-related configuration that has to do with sizable subsystems is placed
# under those subsystems; this section contains policies which are simple,
# small, and unlikely to interfere with any site-specific configuration.

class stig_misc {
    include stig_misc::host_based_authn

    case $::osfamily {
        'RedHat': {
# \implements{unixsrg}{GEN001100} Prevent unencrypted terminal access by
# uninstalling \verb!rsh! and \verb!telnet!.
            include rsh::no
            include telnet::no

# \implements{unixsrg}{GEN003860} Remove the finger server.
            package {
                "finger-server": ensure => absent;
            }

# \unimplemented{unixsrg}{GEN000450}{The STIG requires to limit users
# to 10 simultaneous logins. Many people here, including Jared, run
# more than 10 xterms routinely, each of which is a ``login''; logging
# in using ssh fails if the maximum logins are not set high enough.}
            class { 'pam::max_logins':
                limit => 30,
            }

# \implements{unixsrg}{GEN000480} Make the system delay at least 4 seconds
# following a failed login.
            class { 'pam::faildelay':
                seconds => 4,
            }

            include stig_misc::login_history
            include stig_misc::permissions
            include stig_misc::startup_files
            include stig_misc::system_files
            include stig_misc::library_files
            include stig_misc::man_page_files
            include stig_misc::skel
            include stig_misc::xinetd
            include stig_misc::run_control_scripts
            include stig_misc::device_files
            include stig_misc::find_uneven
            include stig_misc::world_writable
        }
# The Mac OS X STIG stuff is all taken care of elsewhere.
        'Darwin': {}
        default: { unimplemented() }
    }
}
