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
# \section{umask}
#
# The \emph{umask} is a set of permissions to \emph{remove} from new
# files being created. For example, files created by a process running
# with a umask of \verb!022! will not be writable by their owning
# group nor everyone else. So the umask acts to provide default file
# permissions. It is inherited by children of a process, so it's
# important to set the umask in shells and process launchers of all
# sorts to ensure that discretionary access controls act to provide
# security.
