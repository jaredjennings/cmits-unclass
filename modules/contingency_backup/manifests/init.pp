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
# \section{Contingency backup}
#
# \implements{iacontrol}{COSW-1,DCHW-1}%
# Back up this \CMITSPolicy , along with organization-specific critical
# software and documentation, monthly onto read-only media.
#
# (Regarding provisions for data backup in general, see the backup plan and
# contingency and business continuity plan [CBCP].)
#
# Because this policy plays such an integral part in the installation and
# configuration of all sorts of hosts, you, the administrator, need it
# just as urgently during a contingency as you need the operating system
# install media. So this policy needs to be written on a CD or DVD, along with
# any software it installs which cannot be found on the vendor-provided install
# media---irrespective of other means by which it may also be backed up. And
# hosts which include this class will do just that.
#
# \implements{macosxstig}{OSX00675 M6}%
# This \CMITSPolicy\ comprises a great deal of what is needed to accomplish
# ``recovery of a damaged or compromised [Mac] system in a timely basis.''
# Automated backup of the policy and its dependencies as described in this
# section is therefore an important part of compliance with this
# requirement.
#
# \subsection{Guidance for admins about contingency backups}
#
# \doneby{admins}{iacontrol}{COSW-1,DCHW-1}%
# Store the contingency backup in a fire-rated container.
#
# \doneby{admins}{macosxstig}{OSX00675 M6}%
# Lock the fire-rated container which holds the contingency backups.
#
# Keep a ready supply of CD labels and DVDs. You must receive and abide by the
# automated email instructions, which are emailed to root (see
# \S\ref{define_smtp::root}). Maintain the automated backup script, so that it
# continues to correctly obtain and back up critical information for all
# automated information systems to which it pertains. This critical
# information is hardware baselines, software baselines, administrative
# manuals, custom software: everything needed to reconstitute each AIS.
#
# The choices of which content to back up are laid out in
# \verb!critical-backup!, which lives separately from this \CMITSPolicy\ in a
# Subversion repository.
