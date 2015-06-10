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
# \subsection{Device files}
#
# \implements{unixsrg}{GEN002260} Check for extraneous device files at least
# weekly.
#
# It appears on RHEL6 that \verb!/dev! is on a different filesystem from
# \verb!/!, so using the \verb!-xdev! switch, in addition to excluding NFS
# filesystems, excludes \verb!/dev!, with the happy result that any device
# files found by this command are extraneous, so no further filtering is
# necessary.

class stig_misc::device_files {
    file { "/etc/cron.weekly/device-files.cron":
        owner => root, group => 0, mode => 0700,
        source => "puppet:///modules/stig_misc/\
device_files/device-files.cron",
    }
}
