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
# \subsection{Run Puppet client automatically}
#
# Arrange for the Puppet client to be run automatically.

class puppet::client {

    case $::osfamily {
        'RedHat': {
            case $::operatingsystemrelease {
                /^6\..*/: {
                    package { 'puppet':
                        ensure => installed,
                    }
# If the Puppet agent is running on a host, we can assume that the
# Puppet package is installed, which defines the service named
# above. If the agent is not running on a host, that host will not be
# paying attention to this:
                    service { 'puppet':
                        enable => true,
                        ensure => running,
                    }
                }
                /^5\..*/: {
                    package { 'apscl':
                        ensure => installed,
                    }
                    service { 'apscl-puppet':
                        enable => true,
                        ensure => running,
                    }
                    file { '/usr/bin/puppet':
                        ensure => present,
                        owner => root, group => 0, mode => 0755,
                        content => "#!/bin/sh
scl enable apscl \"puppet \$*\"
",
                    }
                    file { '/usr/bin/facter':
                        ensure => present,
                        owner => root, group => 0, mode => 0755,
                        content => "#!/bin/sh
scl enable apscl \"facter \$*\"
",
                    }
                }
            }
        }
        'Darwin': {
            $service_name = 'mil.hpc.eglin.puppet'
            mac_launchd_file { $service_name:
                description => 'Puppet client daemon',
                environment => {
                    'PATH' =>    '/sbin:/usr/sbin:/bin:/usr/bin',
                    'RUBYLIB' => '/usr/lib/ruby/site_ruby/1.8',
                },
                arguments => [
                    '/usr/bin/puppet',
                    'agent',
                    '--verbose',
                    '--no-daemonize',
                ],
            } ~>
            service { $service_name:
                enable => true,
                ensure => running,
                require => Mac_launchd_file[$service_name],
            }
        }
        default: { unimplemented() }
    }

# It may be better to run the agent with cron rather than have it hanging about
# and growing in size. We'll see if that becomes a problem.
#
# Let admins run the Puppet commands with environment variables set.
    sudo::auditable::command_alias { 'PUPPET_BINARIES':
        type => 'setenv_exec',
        commands => [
            '/usr/bin/puppet',
            '/usr/bin/facter',
            ],
    }
}
