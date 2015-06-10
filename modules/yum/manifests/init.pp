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
# \section{YUM (Yellowdog Updater, Modified)}
#
# GPG signatures are not checked on package install during kickstart, but they
# are checked weekly after that (see~\S\ref{module_rpm}). The mitigation is
# that the kickstart network is more trusted than the production network.
# See~\S\ref{Kickstarting}.
#
# \subsection{Admin guidance about yum}
#
# \doneby{admins}{unixsrg}{GEN008800}%
# Do not deploy any YUM repository configuration with \verb!gpgcheck=0!. Do
# sign packages. See~\S\ref{Packaging}.
