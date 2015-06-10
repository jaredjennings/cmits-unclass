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
# \subsection{Manual page file permissions}

class stig_misc::man_page_files {
# \implements{unixsrg}{GEN001280}%
# \implements{macosxstig}{GEN001280 M6}%
# Lock down permissions for manual page files.
#
# (There are so many of these that specifying policy for them using the file
# resource type ran into speed and memory problems.)

    $man_page_dirs = ['/usr/share/man']

# \index{portability}%
# We use the \verb!-perm +! syntax for \verb!find! even though it is deprecated
# by GNU find, because Mac OS X's \verb!find! doesn't understand the
# recommended \verb!-perm /! syntax.

    exec { "chmod_man_pages":
        path => ['/bin', '/usr/bin'],
        command => "chmod -c -R go-w ${man_page_dirs}",
        onlyif  => "find ${man_page_dirs} \
                \\! -type l -perm +022 | \
            grep . >&/dev/null",
        logoutput => true,
    }
    exec { "chown_man_pages":
        path => ['/bin', '/usr/bin'],
        command => "chown -c -R root:0 ${man_page_dirs}",
        onlyif  => "find ${man_page_dirs} \
                \\! -user root -o \\! -group 0 | \
            grep . >&/dev/null",
        logoutput => true,
    }
# \implements{unixsrg}{GEN001290}%
# \implements{macosxstig}{GEN001290 M6}%
# Remove any extended ACLs from manual page files.
    no_ext_acl { "/usr/share/man": recurse => true }
}
