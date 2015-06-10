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
# \section{PostgreSQL database server}
#
# Being a client-server Database Management System (DBMS), PostgreSQL is
# subject to the General Database STIG \cite{database-stig}. As with any STIG,
# some requirements can be automatically enforced by this policy and some are
# up to database administrators (DBAs), system administrators (SAs) and users
# to fulfill on an ongoing basis.
#
# This class has to do with PostgreSQL servers. Policy-based PostgreSQL client
# configuration will be under postgresql::client; this is not yet written.

class postgresql($audit_data_changes = false) {

    require postgresql::initialize
    service { "postgresql":
        enable => true,
        ensure => running,
        require => Class['postgresql::initialize'],
# Don't interrupt service when settings change. If postgresql.conf changes and
# the server needs to be restarted, not reloaded, that should happen during
# some planned downtime or something.
        restart => "/sbin/service postgresql reload",
    }

# Get rid of the wide-open initially installed connection permissions (and any
# wide-open permissions that follow).
    augeas { 'remove_hba_wideopen_defaults':
        context => '/files/var/lib/pgsql/data/pg_hba.conf',
        changes => [
            'rm *[database="all"]',
        ],
        require => Exec['postgresql_initdb'],
        notify => Service['postgresql'],
    }
# But make sure postgres can still connect to the postgres database.
    postgresql::allow_local { 'postgres':
        database => 'postgres'
    }

# Now apply STIG-based policies regarding the server configuration, and add
# users for Puppet and for admins.
    class { 'postgresql::stig':
        audit_data_changes => $audit_data_changes,
    }
    include postgresql::puppet_dba
    include postgresql::roles
}
