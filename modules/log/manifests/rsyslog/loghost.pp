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
# \subsection{Configuring a loghost}
#
# \doneby{admins}{unixsrg}{GEN005460}%
# The ``site-defined procedure'' for setting up and documenting a loghost is
# this:
#
# \begin{enumerate}
# \item Write \verb!include log::loghost! in the node declaration in
# \S\ref{nodes}.
# \item Immediately before this, write a comment containing the tag \verb!\documented{unixsrg}{GEN005460}! and the justification for that host to be a loghost.
# \end{enumerate}
#
# \bydefault{RHEL5}{unixsrg}{GEN005480}%
# RHEL5 does not receive syslog messages by default (see
# \verb!/etc/sysconfig/syslog!).
# \bydefault{RHEL6}{unixsrg}{GEN005480}%
# RHEL6 does not receive syslog messages by default (see
# \verb!/etc/rsyslog.conf!).
# \doneby{admins}{unixsrg}{GEN005480}%
# To prevent inadvertent disclosure of sensitive information, do not configure
# any host to listen for log messages over the network by any other means than
# the above procedure.
#
# Now, this is how a loghost so documented is configured:

class log::rsyslog::loghost($networkname) {
    include log::rsyslog

# Install the SELinux rules that let rsyslogd listen to clients.
    $selmoduledir = "/usr/share/selinux/targeted"
    file { "${selmoduledir}/rsyslog_loghost.pp":
        owner => root, group => 0, mode => 0644,
        source => "puppet:///modules/log/rsyslog/\
rsyslog_loghost.selinux.pp",
    }
    selmodule { "rsyslog_loghost":
       ensure => present,
       syncversion => true,
       notify => Service['rsyslog'],
    }

# The loghost needs a certificate, which will also be distributed to each log
# client.
#
# The loghost needs a copy of the CA certificate(s) which have signed the
# certificates of the log clients.
#
# The locations of these files are written in the \verb!rsyslog.conf! file.

    file { '/etc/rsyslog.d/20loghost.conf':
        owner => root, group => 0, mode => 0640,
        content => template(
            'log/rsyslog/loghost-only/20loghost.conf'),
        notify => Service['rsyslog'],
    }

# Export the to\_loghost resource so that clients can pick it up.
    @@log::rsyslog::to_loghost { "$::fqdn":
        networkname => $networkname,
        ipaddress => $::ipaddress,
    }
}
