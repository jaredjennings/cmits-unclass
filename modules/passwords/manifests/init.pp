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
# \section{Passwords}
# \label{passwords}
#
# Implement guidelines regarding passwords.
#
# \subsection{Admin guidance about passwords}
#
# The 2006 UNIX STIG required these things: (GEN000720) Change the root
# password at least every 90 days. (GEN000840) Don't give the root password to
# anyone besides security and administrative users requiring access. Such users
# must be listed under \S\ref{DocumentedWithIAO}. (GEN000860) Change the root
# password whenever anyone who has it is reassigned.
#
# \doneby{admins}{unixsrg}{GEN000740}%
# Change passwords for non-interactive or automated accounts at least once a
# year, and whenever anyone who has one is reassigned.
