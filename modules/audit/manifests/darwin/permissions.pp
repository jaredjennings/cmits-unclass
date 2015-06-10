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
# \subsubsection{Mac OS X audit log permissions}
#
# The name of this resource is the directory where audit log files are
# kept. By default this is \verb!/var/audit!. This is a defined
# resource type and not a class so that permissions can be imposed on
# any audit log directory that may be configured, because the STIG
# check and fix texts dictate that permissions be checked and fixed on
# any directory (and files therein) listed in the audit configuration
# file, not just the usual place.

define audit::darwin::permissions() {
    $dir = $name

# \implements{mlionstig}{OSX8-00-00210,OSX8-00-00340,OSX8-00-00355}%
# Fix owner and group of audit log files to \verb!root:wheel!.
# \implements{mlionstig}{OSX8-00-00215,OSX8-00-00365}%
# Fix owner and group of audit log folder to \verb!root:wheel!.
    file { $dir:
        owner => root, group => wheel,
        recurse => true,
    }

# We can't implement the permissions with the file resource type
# because the required permissions are different for the directory and
# the files inside it.

    Exec {
        path => ['/bin', '/usr/bin'],
    }
# \implements{macosxstig}{GEN002680 M6,GEN002690 M6,GEN002700 M6}%
# \implements{mlionstig}{OSX8-00-00205,OSX8-00-00335,OSX8-00-00350}%
# Fix permissions of audit log files.
    exec { "chmod ${dir} files":
        command => "find ${dir} -mindepth 1 -print0 | \
        xargs -0 chmod 0440",
        onlyif  => "find ${dir} -mindepth 1 \\! -perm 0440 | \
        grep . >&/dev/null",
    }
# \implements{mlionstig}{OSX8-00-00220,OSX8-00-00370}%
# Fix permissions of audit log directory.
    exec { "chmod ${dir} directory":
        command => "chmod 700 ${dir}",
        onlyif  => "stat -f '%Lp' ${dir} | grep -v ^700\$",
    }
# \implements{mlionstig}{OSX8-00-00225,OSX8-00-00345,OSX8-00-00375}%
# Remove extended ACLs from audit log files.
    no_ext_acl { $dir:
        recurse => true,
    }
}
