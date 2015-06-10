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
# \subsection{The backup host}
#
# A backup host does the backing up. It needs the ability to send
# messages via SMTP to administrators, an optical drive capable of
# writing, and a printer. It should be a machine to which admins have
# frequent physical access. It must be able to check out the policy
# from the Subversion server non-interactively. And it must have
# elevated access to some NFS shares upon which critical system
# administration data is stored, that it can read some files that only
# root can read, and so that it can write a backup stamp file.
#
# There can and should be more than one backup host. Machinery is built into
# the backup script so that between all backup hosts only one backup will be
# made per month.
#
# Executables necessary to build the CMITS policy must be present and
# runnable by the \verb!nobody! user.

class contingency_backup::host(
    $contingency_backup_url,
    $add_to_path,
    $add_to_pythonpath,
    $stamp_directory,
    ) {
    include common_packages::make
    include common_packages::unix2dos
    include common_packages::latex
    include subversion::pki
    package { [
            'file',
            'dvd+rw-tools',
            'ImageMagick',
            'iadoc',
            'iacic',
# These two are for the empty-optical-disc-awaiter script.
            'pygobject2',
            'dbus-python',
        ]:
        ensure => present,
    }

    file { "/etc/cron.daily/contingency_backup.cron":
        owner => root, group => 0, mode => 0700,
        content => template("contingency_backup/cron.erb"),
    }
}
