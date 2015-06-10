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
# \subsection{Quick-to-enforce home policies}
#
# This defined resource type contains policies regarding the home directory
# that can likely be enforced in under five seconds per home directory.

define home::quick() {
    $s = split($name, ':')
    $dir = $s[0]
    $uid = $s[1]
    $gid = $s[2]

    File {
        owner => $uid, group => $gid, mode => 0640,
    }

    file {
# \implements{unixsrg}{GEN001480,GEN001500,GEN001520}%
# Secure home directories.
        "${dir}":
            ensure => directory,
            recurse => false,
            mode => 0700;

# \implements{macosxstig}{GEN001860 M6}%
# \implements{unixsrg}{GEN001860,GEN001870,GEN001880}%
# Secure local initialization files.
        "${dir}/.bash_profile":;
        "${dir}/.bash_login":;
        "${dir}/.profile":;
        "${dir}/.bashrc":;
        "${dir}/.bash_logout":;

        "${dir}/.tcshrc":;
        "${dir}/.cshrc":;
        "${dir}/.history":;
        "${dir}/.login":;
        "${dir}/.logout":;
        "${dir}/.cshdirs":;

# Additional required by Mac OS X STIG.
        "${dir}/.env":;
        "${dir}/.dtprofile":;
        "${dir}/.dispatch":;
# This is likely a directory, but Puppet will do the right thing with the
# execute bits.
        "${dir}/.emacs":;
        "${dir}/.exrc":;

# \implements{unixsrg}{GEN001980,GEN002040}%
# \notapplicable{unixsrg}{GEN002020,GEN002060}%
# Remove \verb!.rhosts! and \verb!.shosts! files from home directories.
        "${dir}/.rhosts":
            ensure => absent;
        "${dir}/.shosts":
            ensure => absent;
# \implements{macosxstig}{GEN002000 M6}%
# \implements{mlionstig}{OSX8-00-00600}%
# \implements{unixsrg}{GEN002000}%
# Remove \verb!.netrc! files from home directories.
        "${dir}/.netrc":
            ensure => absent;
    }

    no_ext_acl {
# \implements{unixsrg}{GEN001890}%
# Remove extended ACLs for local initialization files.
        "${dir}/.bash_profile":;
        "${dir}/.bash_login":;
        "${dir}/.profile":;
        "${dir}/.bashrc":;
        "${dir}/.bash_logout":;

        "${dir}/.tcshrc":;
        "${dir}/.cshrc":;
        "${dir}/.history":;
        "${dir}/.login":;
        "${dir}/.cshdirs":;
    }

# \implements{macosxstig}{GEN004580 M6}%
# \implements{mlionstig}{OSX8-00-01040}%
# \implements{unixsrg}{GEN004580}%
# Prevent use of the \verb!.forward! file by removing it.
    file { "${dir}/.forward": ensure => absent }

# \implements{iacontrol}{IAIA-1}\implements{databasestig}{DG0067}%
# Prevent use of the \verb!.pgpass! file, which could contain unencrypted
# passwords for the PostgreSQL DBMS.
    file { "${dir}/.pgpass": ensure => absent }

# \implements{mlionstig}{OSX8-00-01130}%
# Get rid of signed-in Apple IDs for iCloud (previously MobileMe, eh).
    $mma = "${dir}/Library/Preferences/MobileMeAccounts.plist"
    exec { "warn of possible signed-in Apple IDs in ${dir}":
        onlyif => "stat ${mma}",
        command => "echo ${mma} exists. \
This may indicate a signed-in Apple ID in violation of the STIG.",
        loglevel => err,
    }
}
