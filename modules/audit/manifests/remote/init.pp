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
# \subsection{Remote audit logging}
#
# % Remove this when remote audit logging is done.
# \doneby{admins}{iacontrol}{ECRG-1}%
#
# Remote audit logging in our environment has the following requirements:
# \begin{enumerate}
# \item Make it harder for an attacker who compromises a server to redact its
# audit log, by sending auditing data from the subject server off to another
# server.
# \item Make it hard for non-admins to see what audit messages result from a
# given stimulus to the server, by hiding audit messages from non-admins.
# \item Use encryption rather than a separate network to do this hiding:
# multiple networks connected to one host can cause allergic reactions in some
# accreditors.
# \item Use a different means of encrypting and sending audit messages than the
# one used for sending system log messages, to avoid a single point of failure.
# (rsyslogd's SSL remote logging seems a bit flaky in practice.)
# \item Be as simple as possible within these constraints.
# \end{enumerate}
#
# The Linux auditing subsystem supports encrypted remote audit logging using
# Kerberos for authentication and encryption. For each host sending its audit
# data off remotely, there must be a Kerberos principal. In order to avoid
# imposing the unique security requirements of the auditing subsystem on any
# organization-wide Kerberos deployment, a Kerberos realm dedicated for remote
# auditing is set up.

