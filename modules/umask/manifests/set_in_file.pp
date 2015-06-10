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
# \subsection{Set umasks in shell startup files}
#
# This defined resource type can make sure a umask is set properly in
# a file. It works if the syntax of the umask command is, e.g.,
# \verb!umask 077!, and if lines added to the end of the file will
# have the proper effect. You have to ensure the file is present
# yourself.
#
# \begin{verbatim}
# umask::set_in_file { '/etc/bashrc': umask => 077 }
# \end{verbatim}
# \dinkus

define umask::set_in_file($umask) {
    $sed_i_umask = $::osfamily ? {
        'RedHat' => 'sed -i.before_umask',
        'Darwin' => 'sed -i .before_umask',
        default  => unimplemented(),
    }
    exec { "add umask ${umask} to ${name}":
        command => "echo 'umask ${umask}' >> ${name}",
        unless => "grep '^[[:space:]]*umask' ${name}",
        path => ['/bin', '/usr/bin'],
        require => File[$name],
    }
    exec { "change umask to ${umask} in ${name}":
        command => "${sed_i_umask} -e \
        's/\\(^[[:space:]]*umask\\>\\).*/\\1 ${umask}/' \
        ${name}",
        onlyif => "grep '^[[:space:]]*umask' ${name} | \
        grep -v 'umask ${umask}\$'",
        path => ['/bin', '/usr/bin'],
    }
}
