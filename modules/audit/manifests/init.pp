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
# \section{Auditing subsystem}
# \label{audit}
#
# % ECAN-1, implementation guidance, (2)(f) requires auditing.
#
# \implements{iacontrol}{ECAN-1,ECRR-1}%
# Activate audit logging; configure it in a compliant fashion; and protect and
# retain audit logs.
#
# The sense in which we implement ECRR-1, Audit Record Retention, here in this
# section, is that retention includes making sure the logs are not overwritten,
# nor modified or deleted by unauthorized users. The narrower sense of
# retention, ``moving audit trails from on-line to archival media,'' is handled
# by backing up the audit logs in the same way as the rest of the logs.
# See~\S\ref{module_log}.
#
# \unimplemented{unixsrg}{GEN002870}{The SRG requires remote audit logging. It
# seems that audisp-remote can be used for remote audit logging, but it needs a
# Kerberos infrastructure first. So we do not yet have a remote audit server.
# We depend on log backups to preserve a remote audit record.}
#
# \implements{iacontrol}{ECAR-2}\implements{databasestig}{DG0140}%
# The auditing rules installed in~\S\ref{audit} fulfill Database STIG
# requirements.

class audit {
    include "audit::${::osfamily}"
    include audit::file_permissions
}
