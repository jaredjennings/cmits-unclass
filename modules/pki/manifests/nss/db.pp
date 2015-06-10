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
# \subsection{NSS databases}
#
# Some subsystems store their CA certificates in an NSS database rather than a
# directory. Here is how to ensure that such an NSS database exists and is
# ready to have certificates imported into it.
#
# The \verb!pwfile! parameter dictates whether to create a password file along
# with the database. For specific services this may be necessary; for managing
# the systemwide NSS database it should be false.

define pki::nss::db($owner, $group, $mode, $sqlite=true, $pwfile=false) {
    $dbdir = $sqlite ? {
        true  => "sql:${name}",
        false => $name,
    }
    $creates = $sqlite ? {
        true  => "${name}/cert9.db",
        false => "${name}/cert8.db",
    }
# Every NSS database is a directory containing several \verb!.db! files, and is
# referred to using the name of the directory. First, make sure the directory
# exists.
    file { "$name":
        ensure => directory,
        owner => $owner, group => $group, mode => $mode,
        recurse => true,
        recurselimit => 1,
    }
# Then, if there is no certificate database file in the directory, create it.
    case $pwfile {
        true: {
# \emph{certutil} needs the password file, and other automated NSS management
# by Puppet needs the password file; but on production servers the password
# should be saved somewhere and the password file should be deleted, so that
# using the NSS database set up here will require the passphrase to be entered.
            pki::nss::pwfile { "${name}":
                require => File["${name}"],
            } ->
            exec { "create_nssdb_${name}_with_pwfile":
                command => "/usr/bin/certutil \
                    -N -d ${dbdir} -f ${name}/pwfile",
                creates => $creates,
            } ~> # squiggle not dash
            exec { "enable_fips_${name}_with_pwfile":
                refreshonly => true,
                command => "/usr/bin/modutil \
                    -dbdir ${dbdir} \
                    -fips true",
            }
        }
        default: {
# We use \verb!modutil! to create the database. \verb!certutil! would work too,
# but it needs a passphrase.
            exec { "create_nssdb_${name}":
                command => "/usr/bin/modutil \
                    -create \
                    -dbdir ${dbdir} \
                    </dev/null >&/dev/null",
# The redirections get rid of \verb!modutil!'s warning about modifying the
# database while ``the browser is running.'' In a systemwide context this
# doesn't matter.
                require => File["$name"],
                creates => $creates,
            }
# We don't turn on FIPS mode because that would require a password
# before the database could be used, and we didn't set up a password
# file.
        }
    }
}

# In other PKI subsections the above define is used to automate these checks.
