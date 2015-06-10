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
# \subsubsection{Add PostgreSQL ident map entries}
#
# This define is used by the \verb!postgresql::identmap! define, \emph{q.v.}
#
# Since there's likely more than one database user in question, our strategy is
# to define a resource type pertaining to one database user, and pass an array
# of database users in as the name parameter in order to construct an array of
# these defined resources. Search for ``puppet for loop'' to find out more on
# this strategy.

define postgresql::identmap::entry($os_user, $database) {
    $db_user = $name

    include postgresql

# Yes, this is a long name, but it must be unique across the entire manifest.
    augeas { "pg_ident_${os_user}_as_${db_user}_into_${database}":
        context => '/files/var/lib/pgsql/data/pg_ident.conf',
        changes => [
            "set 999/map     '${database}'",
            "set 999/os_user '${os_user}'",
            "set 999/db_user '${db_user}'",
        ],
        onlyif => "match *[map='${database}' and \
                           os_user='${os_user}' and \
                           db_user='${db_user}'] \
                           size < 1",
        require => Exec['postgresql_initdb'],
        notify => Service['postgresql'],
    }
}
