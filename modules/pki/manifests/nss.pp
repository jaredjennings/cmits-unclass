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
# \subsection{NSS and FIPS}
# \label{nss_fips}
#
# Each NSS database has a FIPS-compliance switch, which can be on or off. The
# most visible effect of FIPS compliance is that a passphrase is required
# before any cryptographical work can be done using the contents of the NSS
# database. Some programs (e.g., Apache with \verb!mod_nss!) have their own
# FIPS compliance setting, which may use the database in FIPS mode even if its
# FIPS setting is off.
#
# In order for the FIPS mode to work, a passphrase must be set. The above
# defined resource type does not set a passphrase, so any freshly made database
# will be unusable in FIPS mode.
#
# To make it usable:
# \begin{enumerate}
# \item Turn off FIPS mode if necessary: {\tt modutil -fips false -dbdir
# \emph{directory}}.
# \item Set a passphrase on it: {\tt modutil -changepw "NSS Certificate DB"
# -dbdir \emph{directory}}.
# \item Turn on FIPS mode if necessary: {\tt modutil -fips true -dbdir
# \emph{directory}}.
# \item You will need to type that passphrase every time you start the server.
# \item Do not write the passphrase in a file. This would enable services that
# need to use NSS for encryption, like Apache with \verb!mod_nss!, to do so
# without prompting for the passphrase. It would also enable a remote attacker
# who compromised such a service to get at the private keys immediately,
# without needing to brute-force the passphrase. 
# \item Such a file has the following format: Each line of the file should look
# like {\tt \emph{module}:\emph{password}}. The modules of interest are
# ``internal'', ``NSS Certificate DB'' and
# ``NSS FIPS 140-2 Certificate DB''.
# \end{enumerate}
#
# \doneby{admins}{unixsrg}{GEN000740}%
# You should change the passphrase at least once every year, because it's
# analogous to a non-interactive account password.
#
#
#
# % No Puppet code is in this file.
