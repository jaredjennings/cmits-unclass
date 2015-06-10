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
# \subsection{Get filer users from an agent host}
#
# With an integration between Active Directory and UNIX hosts such as
# Centrify, UNIX users need to be populated to the filer. This define
# gathers non-system users from a host and places them in group and
# passwd files in the filer's \verb!etc! directory, which is indicated
# by the name of the resource.

define filers::users_from_agent($etc_dir, $ensure='present') {
    include filers::remove_old_users_from_agent
    file { "/etc/cron.hourly/${name}_users_and_groups":
        owner => root, group => 0, mode => 0755,
        content => template('filers/users_to_filer.cron'),
        ensure => $ensure,
    }
}
