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
# \subsection{Smart hosts}
#
# A \emph{smart host}, or \emph{relay host}, is a mail server through which all
# outgoing mail should be routed. The smart host, then, is the host that
# connects to a destination mail server to deliver the mail, not the host where
# the mail originated. This is useful in cases where the originating host is
# behind some sort of firewall and cannot connect to destination mail servers
# itself.
#
# This is a defined resource type so that it can be exported and collected.

define smtp::use_smarthost() {
    case $::osfamily {
        'RedHat': {
            case $::operatingsystemrelease {
                /^6\..*/: {
                    smtp::use_smarthost::postfix { $name: }
                }
                default: { unimplemented() }
            }
        }
        default: { unimplemented() }
    }
}
