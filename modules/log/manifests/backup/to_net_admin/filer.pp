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
# This is what the filer policy agent (see~\ref{module_filers}) must do to
# enable log backups to \verb!/net/admin!.

class log::backup::to_net_admin::filer {
    file { "/net/admin/BACKUPS":
        ensure => directory,
        owner => root, group => skadmin, mode => 2770,
    }

# Collect the directories each host has requested; implement those policies on
# the filer policy agent host.
    Log::Backup::To_net_admin::For_host <<| |>>


# Clean out old logs. Keep logs for five years, just in case we have sources
# and methods intelligence (SAMI) on some host. Disks are cheap, noncompliance
# expensive.
    tidy { "/net/admin/BACKUPS":
        recurse => 2,
        matches => "system_logs-*.tar.gz",
        age => "5y",
    }
}
