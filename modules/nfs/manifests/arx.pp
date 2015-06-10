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
# \subsection{ARX workaround}
#
# According to
# \url{http://support.f5.com/kb/en-us/solutions/public/14000/400/sol14478.html?sr=35037786},
# a change was made in RHEL 6.3 to enable more remote procedure calls
# to be in-flight between the client system and an NFS server. The ARX
# is ill-equipped to handle many in-flight RPCs, though, so we must
# limit the RHEL systems back to previous behavior to avoid flooding
# the ARX.

class nfs::arx {
    case $::osfamily {
        'RedHat': {
            file { '/etc/modprobe.d/sunrpc.conf':
                owner => root, group => 0, mode => 0644,
                content => "
options sunrpc tcp_max_slot_table_entries=16
",
            }
        }
        default: {}
    }
}
