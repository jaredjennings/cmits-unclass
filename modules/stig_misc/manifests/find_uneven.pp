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
# \subsection{Uneven access permissions}
#
# \implements{unixsrg}{GEN001140}%
# \implements{macosxstig}{GEN001140 M6}%
# Check for system files and directories having ``uneven access permissions.''

class stig_misc::find_uneven {

    $system_dirs = "/etc /bin /usr/bin /sbin /usr/sbin"
       
# Because the exec to find uneven permissions is long and we need to do it
# three times, we define a resource type to do it.
#
# Usage:
# \begin{verbatim}
#     _log_uneven { 'bla_bla_title':
#           bit => '4', 
#           paths => ['/bin', '/usr/bin', '/etc'],
#     }
# \end{verbatim}
#
# The effect of the above is that if files with uneven read permissions exist
# (because read is the 4 bit in the mode of a directory entry, see
# \verb!chmod(1)!) in \verb!/bin!, \verb!/usr/bin!, or \verb!/etc!, the names
# of these files will be logged as errors.
    define log_uneven($bit, $paths) {
        exec { "log_uneven_permissions_${name}":
            path => ['/bin', '/usr/bin'],
            logoutput => true,
            loglevel => err,
# The two clauses here find (1) files having the bit for the group but not for
# the user, and (2) files having the bit for other but not for the user.
            command => "find ${paths} \
                -perm -0${bit}0 \\! -perm -${bit}00 -ls -o \
                -perm -00${bit} \\! -perm -${bit}00 -ls",
# In order to avoid having err-level log messages only stating ``executed
# successfully,'' we only execute the command above if it would produce any
# output.
            onlyif => "find ${paths} \
                -perm -0${bit}0 \\! -perm -${bit}00 -ls -o \
                -perm -00${bit} \\! -perm -${bit}00 -ls | \
                grep . >&/dev/null",
        }
    }

# And now we use our defined resource type.
    log_uneven { 'system_files_read':
        bit => '4',
        paths => $system_dirs,
    }
    log_uneven { 'system_files_write':
        bit => '2',
        paths => $system_dirs,
    }
    log_uneven { 'system_files_execute':
        bit => '1',
        paths => $system_dirs,
    }
}
