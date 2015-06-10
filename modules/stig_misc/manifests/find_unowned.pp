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
# \subsection{``Unowned'' files}
#
# \implements{unixsrg}{GEN001160,GEN001170}%
# \implements{macosxstig}{GEN001160 M6,GEN001170 M6}%
# Check for files and directories with unknown owners.
#
# We assume here that any NFS filesystem which may be mounted will be under
# \verb!/net!. If that assumption does not hold, we'll end up searching across
# an NFS filesystem. That could take a while and spit out a bunch of errors.

class stig_misc::find_unowned {
    exec { 'files_with_unknown_owner_or_group':
        path => ['/bin', '/usr/bin'],
        command => "find / -path /net -prune -o \
                -nouser -ls -o \
                -nogroup -ls",
        logoutput => true,
        loglevel => err,
    }
}
