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
# \subsection{Allow a local PostgreSQL user}
#
# This defined resource type is a shortcut to let a given user local to
# the DBMS server connect to a given database with the same username between
# the OS and database. Real people should connect this way.

define postgresql::allow_local($database) {
    require postgresql::initialize
    include postgresql
# This depends on the postgresql class, but since it will most likely
# be used from inside that class, notating such a dependency would
# result in a dependency cycle.
    augeas { "pg_hba_${name}_into_${database}":
        context => '/files/var/lib/pgsql/data/pg_hba.conf',
        changes => [
            'set 999/type      local',
            "set 999/database  '${database}'",
            "set 999/user      '${name}'",
            'set 999/method    ident',
        ],
        onlyif => "match *[user='${name}'] size < 1",
        require => Class['postgresql::initialize'],
        notify => Service['postgresql'],
    }
}
