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
# \subsection{profile.d permissions}
#
# Set permissions for ``global initialization files'' according to the UNIX
# SRG.

class shell::global_init_files {

# \implements{unixsrg}{GEN001720,GEN001740,GEN001760}%
# \implements{macosxstig}{GEN001720 M6,GEN001740 M6,GEN001760 M6}%
# Make sure that no one can influence the environment variables set when the
# shell starts, except for root.
#
# On the Mac, \verb!/etc/profile.d! is not a usual place for global
# initialization files, but we put it there.
    $glif_owner = $::osfamily ? {
        'redhat'  => bin,
        'darwin'  => root,
        default => root,
    }
    File {
        owner => $glif_owner,
        group => 0,
        mode => 0444,
    }
    file {
        "/etc/profile.d":
            ensure => directory,
            recurse => true, recurselimit => 2;
        "/etc/profile": ensure => present;
        "/etc/bashrc":;
        "/etc/csh.login":;
        "/etc/csh.logout":;
        "/etc/csh.cshrc":;
    }

# \implements{unixsrg}{GEN001730}%
#
# Remove extended ACLs on shell startup files.
    no_ext_acl {
        "/etc/profile.d": recurse => true;
        "/etc/profile":;
        "/etc/bashrc":;
        "/etc/csh.login":;
        "/etc/csh.logout":;
        "/etc/csh.cshrc":;
    }
}
