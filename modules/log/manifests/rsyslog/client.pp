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
# \subsection{Configuring remote logging clients}
#
# (This excludes configuration of exactly which log server to use; see
# \S\ref{define_log::rsyslog::to_loghost}.)

class log::rsyslog::client($networkname) {
    include log::rsyslog
# Install the SELinux rules that let rsyslogd talk to the loghost.
    $selmoduledir = "/usr/share/selinux/targeted"
    file { "${selmoduledir}/rsyslog_client.pp":
        owner => root, group => 0, mode => 0644,
        source => "puppet:///modules/log/rsyslog/\
rsyslog_client.selinux.pp",
    }
    selmodule { "rsyslog_client":
       # autorequires above file
       ensure => present,
       syncversion => true,
       notify => Service['rsyslog'],
    }

# Collect the to\_loghost resource exported by the loghost.
    Log::Rsyslog::To_loghost <<| 
        networkname == $networkname
    |>>

# The client needs a certificate that the server will recognize in order to connect.
#
# The client needs the CA certificate(s) installed so it can authenticate the
# server.
#
# Configuration of the rsyslogd (\verb!/etc/rsyslog.conf!) is set in
# \S\ref{define_log::rsyslog::to_loghost} because it depends on the loghost's address.

}
