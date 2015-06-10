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
# \subsubsection{Under RHEL5}
#
# Here we have guidance from the Red Hat 5 STIG---specific, if unclear.

class user::unnecessary::rhel5 {
# \implements{rhel5stig}{GEN000000-LNX00320} Remove the \verb!shutdown!,
# \verb!halt!  and \verb!reboot! users. The requirement says to remove
# ``special privilege accounts'' but only mentions these three.
    user { ["shutdown", "halt", "reboot"]:
        ensure => absent,
    }
# \implements{rhel5stig}{GEN000290-1,GEN000290-2,GEN000290-3,GEN000290-4}%
# Remove the \verb!games!, \verb!news!, \verb!gopher! and \verb!ftp! accounts.
#
# (The \verb!ftp! account is taken care of in \S\ref{class_ftp::no}.)
    user { ['games', 'news', 'gopher']:
        ensure => absent,
    }

}
