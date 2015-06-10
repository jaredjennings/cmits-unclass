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
# \subsection{Library files}

class stig_misc::library_files {
# \implements{macosxstig}{GEN001300 M6}%
# Lock down permissions for ``library files.''
    $library_dirs = $::osfamily ? {
        'darwin' => [ '/System/Library/Frameworks',
                     '/Library/Frameworks',
                     '/usr/lib',
                     '/usr/local/lib' ],
        'redhat' => [ '/lib', '/lib64',
                     '/usr/lib', '/usr/lib64',
                     '/usr/local/lib', '/usr/local/lib64' ],
        default  => [ '/usr/lib', '/usr/local/lib' ],
    }
    file { $library_dirs:
        mode => go-w,
    }

# \implements{macosxstig}{GEN001310 M6}%
# \implements{unixsrg}{GEN001310}%
# Remove any extended ACLs from library files.
    no_ext_acl { $library_dirs: recurse => true }
}
