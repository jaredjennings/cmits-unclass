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
# \section{TCP Wrappers}
# \bydefault{RHEL5, RHEL6}{unixsrg}{GEN006580}%
# RHEL comes with TCP wrappers enabled by default.
#
# \bydefault{RHEL5, RHEL6}{unixsrg}{GEN006600}%
# ``The system's access control program must log each system access attempt.''
# RHEL logs all access attempts by default.
#
# TCP wrappers are used within this policy solely to control SSH access. RHEL's
# \verb!sshd! logs all successful and failed access attempts. This materially
# prevents ``multiple attempts to log on to the system by an unauthorized
# user'' from ``go[ing] undetected.'' If we were to enable additional services
# using xinetd, it would also log all connection attempts by default.
#
# Services which are not implemented on a host are not presently booby-trapped
# using TCP wrappers, so unauthorized users could (for example) attempt to
# telnet to a host repeatedly, and nothing would be logged by ``the system's
# access control program.'' That would result in incoming packets which are not
# explicitly allowed, which would most likely be logged via other means: see
# \S\ref{class_iptables}.
#
# \implements{unixsrg}{GEN006620}%
# Configure {\tt tcp\_wrappers} to grant or deny system access to specific
# hosts.
#
# Use of the \verb!tcp_wrappers::allow! defined resource type below will
# ``configure'' TCP wrappers ``with appropriate rules.''
