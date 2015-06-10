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
# \subsection{STIG-required RPM package manager configuration}
class rpm::stig($known_unsigned_packages=[]) {
# \implements{unixsrg}{GEN006565} Use the RPM package manager's verify feature
# to cryptographically verify the integrity of installed system software
# monthly.
#
# \implements{iacontrol}{DCSW-1}\implements{databasestig}{DG0021}%
# Use RPM's verify feature to cryptographically verify the integrity of
# installed software for DBMSes included with RHEL.
    file { "/etc/cron.monthly/rpmV.cron":
        owner => root, group => 0, mode => 0700,
        source => "puppet:///modules/rpm/rpmV.cron",
    }
# \implements{unixsrg}{GEN008800} Make sure all packages installed have
# cryptographic signatures.
#
# (\verb!rpm -V! as above will warn about files which have been changed since
# they were installed, but if the installed package is not signed, files from
# an untrusted source could have been installed via the package system.)
#
# Some packages may not be signable. If so, list them in the
# \verb!known_unsigned_packages! parameter to this class. You should
# not share the list of these with the world, because it is a list of
# weaknesses.

    file { "/etc/cron.weekly/rpm-signatures.cron":
        owner => root, group => 0, mode => 0700,
        content => template("rpm/rpm-signatures.cron.erb"),
    }
}
