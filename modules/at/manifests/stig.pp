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
# \subsection{STIG-required configuration for the at subsystem}

class at::stig {
    case $::osfamily {
        'redhat': { include at::stig::redhat }
        'darwin': { include at::stig::darwin }
        default:  { unimplemented() }
    }
}

# \subsection{Guidance for admins about the at subsystem}
#
# \doneby{admins}{unixsrg}{GEN003360}%
# Never run a group-writable or world-writable program with \verb!at!.
# \doneby{admins}{unixsrg}{GEN003380}%
# Never run a program using \verb!at! which is in or anywhere under a
# world-writable directory (such as \verb!/tmp!).
# \doneby{admins}{macosxstig}{GEN003440 M6}%
# \doneby{admins}{unixsrg}{GEN003440}%
# Don't change the umask in an \verb!at! job.
