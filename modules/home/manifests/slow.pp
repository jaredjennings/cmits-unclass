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
# \subsection{Slow-to-enforce home directory policies}
#
# This defined resource type contains policies that will likely take minutes or
# longer to enforce for a user with many files.

define home::slow() {
    $s = split($name, ':')
    $dir = $s[0]
    $uid = $s[1]
    $gid = $s[2]

# \implements{macosxstig}{GEN001540 M6,GEN001550 M6}%
# \implements{unixsrg}{GEN001540,GEN001550,GEN001560}%
# Control ownership and permissions on files contained in home directories.
#
# It appears that ``contained in'' is intended to mean \emph{anywhere under}
# the home directory. File resources seem to run slowly and take a lot of
# memory in the case of thousands of files; so we use \verb!find!,
# \verb!xargs!, \verb!chown! and \verb!chmod!.  (See
# \ref{class_stig_misc::permissions} for more details on this phenomenon.)
#
# The \verb!-r! switch to xargs is a GNU extension which does not run the given
# command if there are no arguments to run it with. According to the man page,
# ``Normally, the command is run once even if there is no input.''
#
# Under Mac OS X, the xargs command does not accept the \verb!-r! switch, but
# it appears that if there are no arguments to consume, xargs will not run the
# given command. That behavior may be documented by this sentence: ``The xargs
# utility exits immediately... if a command line cannot be assembled...''
    $xargs0 = $osfamily ? {
        darwin  => "xargs -0",
        default => "xargs -0 -r",
    }
    exec { "chown_${uid}_home_files":
        path => ['/bin', '/usr/bin'],
        command => "find '${dir}' -mindepth 1 \\( \
                        \\! -user ${uid} -o \\! -group ${gid} \
                        \\) -print0 | \
                    ${xargs0} chown ${uid}:${gid}",
        onlyif => ["test -d '${dir}'",
               "find '${dir}' -mindepth 1 \
                   \\! -user ${uid} -o \\! -group ${gid} | \
                grep . >&/dev/null"],
    }
    exec { "chmod_${uid}_home_files":
        path => ['/bin', '/usr/bin'],
        command => "find '${dir}' -mindepth 1 \\
                        \\! -type l -perm +026 -print0 | \
                    ${xargs0} chmod g-w,o-rw",
        onlyif => ["test -d '${dir}'",
                "find '${dir}' -mindepth 1 \\
                     \\! -type l -perm +026 | \
                 grep . >&/dev/null"],
    }
# \implements{macosxstig}{GEN001490 M6,GEN001570 M6}%
# \implements{unixsrg}{GEN001490,GEN001570}%
# Remove extended ACLs on home directories, and all files and directories
# therein.
    no_ext_acl { "${dir}": recurse => true }
}
