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
# \subsubsection{Backing up logs using NFS}
#
# If you had a \verb!/net/admin! directory mounted on each host, to which logs
# could be backed up, this class would do it.
#
# It may not be required to back up logs daily.

class log::backup::to_net_admin {
    file { "/etc/cron.daily/backup_logs":
        owner => root, group => 0, mode => 0700,
        source => "file:///puppet/modules/log/backup/to_net_admin.sh",
    }

# Tell the filer policy agent to make a directory for the logs to land in.
    @@log::backup::to_net_admin::for_host { "$::hostname": }
}
