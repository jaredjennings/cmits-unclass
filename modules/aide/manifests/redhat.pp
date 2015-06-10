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
# \subsection{AIDE configuration for Red Hat}

class aide::redhat {
    package { "aide":
        ensure => present,
    }

# \implements{unixsrg}{GEN000140,GEN006570,GEN006571,GEN006575}%
# Install the
# prescribed configuration for AIDE, causing it to baseline device files,
# extended access control lists (ACLs), and extended attributes, using FIPS
# 140-2 approved cryptographic hashing algorithms.
#
# \implements{iacontrol}{DCSL-1}\implements{databasestig}{DG0050}%
# Configure AIDE to create and monitor a baseline of database ``software
# libraries, related applications and configuration files.''
    file { "/etc/aide.conf":
        owner => root, group => 0, mode => 0600,
        source => "puppet:///modules/aide/aide.conf",
    }

# Warn if the aide binary changes.
    file { "/usr/sbin/aide":
        audit => all,
    }

# \implements{unixsrg}{GEN000220,GEN002400,GEN002460}%
# Check for unauthorized changes to system files, including setuid files and
# setgid files, every week.
    cron { aide:
        command => "/usr/sbin/aide --check",
        user => root,
        hour => 2,
        minute => 2,
        weekday => 0,
    }

# Make sure aide's logs are rotated.

    augeas { "aide_weekly":
        context => "/files/etc/logrotate.d/aide/rule",
        changes => "set schedule weekly",
    }

# Since aide is run by logrotate, make sure logrotate is working.
#
# \implements{unixsrg}{GEN003100,GEN003120,GEN003140}%
# Use mode \verb!0700! for the daily log rotation script, as required.
    file { "/etc/cron.daily/logrotate":
        owner => root, group => 0, mode => 0700,
        source => "puppet:///modules/aide/logrotate",
    }

# Install the baseline backup script for use by administrators. See
# \S\ref{backup_baseline_usage}.
    file { "/usr/sbin/backup_baseline.sh":
        owner => root, group => 0, mode => 0755,
        source => "puppet:///modules/aide/backup_baseline.sh",
    }
}
