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
# \subsection{Guard hashed passwords}
#
# Make sure that password hashes are not stored in the \verb!/etc/passwd! or
# \verb!/etc/group! files, which are readable to everyone: if everyone can read
# a hashed password, someone can take it somewhere else and figure out the
# password by brute computational force.

class passwords::only_shadow {
# \implements{unixsrg}{GEN001470} Make sure the passwd file does not
# contain password hashes.
#
# (A side effect of this command is to warn if anyone has an empty password in
# \verb!/etc/passwd!.)
    exec { "passwd_no_hashes":
        command => "/bin/grep -v '^[^:]\\+:x:' /etc/passwd",
        onlyif  => "/bin/grep -v '^[^:]\\+:x:' /etc/passwd",
        logoutput => true,
        loglevel => err,
    }
# \implements{unixsrg}{GEN001475} Make sure the group file does not contain
# password hashes.
#
# (A side effect of this command is to warn if any group has an empty password
# in \verb!/etc/group!.)
    exec { "group_no_hashes":
        command => "/bin/grep -v '^[^:]\\+:x:' /etc/group",
        onlyif  => "/bin/grep -v '^[^:]\\+:x:' /etc/group",
        logoutput => true,
        loglevel => err,
    }
}
