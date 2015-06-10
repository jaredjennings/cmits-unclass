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
# \subsection{Administering PostgreSQL using Puppet}
#
# \implements{iacontrol}{ECLP-1}\implements{databasestig}{DG0042}%
# Ensure that ``the DBMS software installation account'' (we take this to mean
# \verb!postgres!, because while that user does not install the DBMS, it owns
# the files in which the DBMS data is stored) ``is only used when performing
# software installation and upgrades or other DBMS maintenance,'' and not for
# ``DBA activities,'' by creating a separate user for automatically enforcing
# policies inside the DBMS.
#
# The \verb!postgres! user must be used to create this user, of course, but
# that should only need to happen once.

class postgresql::puppet_dba {

# Install the Ruby pg module so that \verb!pgsql_role! and
# \verb!pgsql_database! can work.
    package { 'ruby-pg': ensure => present }

# Make a \verb!puppet_dba! OS user and group.
    include user::virtual
    Group <| tag == 'puppet_dba' |>
    User <| tag == 'puppet_dba' |>

# Make a corresponding \verb!puppet_dba! database user.
    pgsql_role { 'puppet_dba':
        os_user => 'postgres',
        db_user => 'postgres',
        database => 'postgres',
        login => true,
        inherit => true,
        superuser => true,
        createdb => true,
        createrole => true,
        require => User['puppet_dba'],
    }

# Make a database for that user to connect to.
    pgsql_database { 'puppet_dba':
        os_user => 'postgres',
        db_user => 'postgres',
        database => 'postgres',
        owner => 'puppet_dba',
    }

# Allow the user to connect to the database.
    postgresql::allow_local { 'puppet_dba':
        database => 'puppet_dba',
    }
}
