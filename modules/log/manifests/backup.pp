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
# \subsection{Log backup}
#
# \verb!rsyslog! should log remotely in most cases, and logs can be backed up
# from the loghost. But limited use in practice indicates that \verb!rsyslog!
# may fail to send log messages under some conditions, and its incomplete PKI
# support means remote logging may become infeasible in our case, given
# security requirements.
#
# Remotely logged messages are saved in files on the loghost. Log messages are
# always written to local files, whether they are sent remotely or not. Audit
# messages are only written to local files: we have no remote audit logging
# capability at present.
#
# \implements{iacontrol}{ECRR-1} Back up audit logs and other logs to archival
# media. Retain them for one year, or five years for systems containing sources
# and methods intelligence (SAMI).
#
# Exactly how logs are backed up and to where depends on to which network a
# host is connected. \verb!log::backup::*! classes make various
# implementations of log backup happen. This \CMITSPolicy\ may not cover the
# entire journey of log backups to archival media: consult the Backup Policy
# \cite{backup-policy} in addition.
