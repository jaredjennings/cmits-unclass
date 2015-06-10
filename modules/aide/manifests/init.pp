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
# \section{Host-based intrusion detection with AIDE}
# \label{aide}
#
# \implements{unixsrg}{GEN000140,GEN006480}%
# \implements{rhel5stig}{GEN000140-2}%
# Install and configure the Advanced Intrusion Detection Environment (AIDE)
# host-based intrusion detection system (IDS) to check system files against a
# list of cryptographic hashes (a baseline) created at install time.
# (See~\S\ref{Baselining} for baseline creation and update procedures.)
#
# \implements{iacontrol}{DCSW-1}\implements{databasestig}{DG0021}%
# For DBMSes included with RHEL, maintain the baseline for database software
# and configuration files along with that of the operating system files. (See
# also~\S\ref{class_rpm::stig}.)
#
# \implements{unixsrg}{GEN002380,GEN002440} Document setuid and setgid files,
# by including them in the baseline of system files.
#
# \implements{unixsrg}{GEN006560} Notify admins of possible intrusions via
# syslog. Remote logging ensures timely notification; for details,
# see~\S\ref{module_log}.
#
# \implements{unixsrg}{GEN008380} Check for rootkits. The AIDE tool does this
# adequately for our needs.

class aide {
    include "aide::${::osfamily}"
}
