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
# \subsection{STIG-required Samba configuration under Mac OS X}

class samba::stig::darwin {

# \implements{macosxstig}{GEN006100 M6,GEN006140 M6}%
# Control ownership and permissions of \verb!smb.conf!. 
    file { "/etc/smb.conf":
        owner => root, group => 0, mode => 0644,
    }

# \implements{macosxstig}{GEN006150 M6}%
# Remove extended ACLs on \verb!smb.conf!.
    no_ext_acl { "/etc/smb.conf": }
}
