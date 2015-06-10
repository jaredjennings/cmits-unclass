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
# \subsection{Sending log messages to a loghost}
#
# \implements{unixsrg}{GEN005450} ``[U]se a remote syslog server (loghost),''
# so that the remotely collected system log data ``can be used as an
# authoritative log source in the event a system is compromised and its local
# logs are suspect,'' and so that it's easier to check logs every day and set
# up automated alerts.
#
# Call this define with the name of the loghost. It must match the common name
# in the loghost's certificate.
#
# The way this happens is that the loghost exports one of these (the Puppet
# term here is ``exported resources''), and the clients collect it. So the name
# parameter is given by the loghost, but the contents of the define happen on
# the clients.
#
# (See~\S\ref{manifests/templates.pp} and~\S\ref{manifests/nodes.pp}
# for places where this defined resource type is used.)

define log::rsyslog::to_loghost($networkname, $ipaddress) {
    $loghost = $name
    file { '/var/spool/rsyslog':
        ensure => directory,
        owner => root, group => 0, mode => 0700,
    }
    file { "/etc/rsyslog.d/80send-to-loghost.conf":
        owner => root, group => 0, mode => 0640,
        content => template(
            'log/rsyslog/client-only/80send-to-loghost.conf'),
        notify => Service['rsyslog'],
        require => File['/var/spool/rsyslog'],
    }
    augeas { "add loghost to /etc/hosts":
        context => "/files/etc/hosts",
        changes => [
            "set 999/ipaddr '$ipaddress'",
            "set 999/canonical '$loghost'",
            "set 999/alias[999] loghost",
        ],
        onlyif => "match *[canonical='$loghost'] size == 0",
    }
}
