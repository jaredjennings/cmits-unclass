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
# \subsection{Ensure validity of password file}
class user::valid {
# \implements{unixsrg}{GEN000300,GEN000320,GEN000380} Make sure that user ids
# and user names are unique across all accounts, and that every user's primary
# group is one defined in the group file.
#
# \implements{unixsrg}{GEN001440,GEN001460} Make sure that all users have a
# home, and that each user's home exists.
    exec { "pwck -r":
        path => "/usr/sbin",
        command => "pwck -r",
        logoutput => on_failure,
        loglevel => err,
        unless => "pwck -r",
    }

# Resolve some complaints about home directories.
    if $::osfamily == 'RedHat' and $::operatingsystemrelease =~ /^6\..*/ {
        $users_array = split($::local_usernames, ' ')
        $has_pulse = inline_template('<%= @users_array.member? "pulse"-%>')
        $has_avahi = inline_template('<%= @users_array.member? "avahi-autoipd"-%>')
        if $has_avahi == 'true' {
            file { '/var/lib/avahi-autoipd':
                ensure => directory,
                owner => 'avahi-autoipd', group => 'root', mode => 0755,
            }
        }
        if $has_pulse == 'true' {
            file { '/var/run/pulse':
                ensure => directory,
                owner => 'pulse', group => 'root', mode => 0755,
            }
        }
    }
}
# About the \verb!unless! above: Jacob Helwig said on the \verb!puppet-users!
# mailing list, 7 Jun 2011,
# \begin{quote}
# By doing the "unless => 'pwck -r'", the resource won't even show up as having
# been run if 'pwck -r' returns 0.  Having to run the command twice is a hack,
# but it's the best I can think of at the moment.
# \end{quote}
# See also \url{http://projects.puppetlabs.com/issues/7877}.

