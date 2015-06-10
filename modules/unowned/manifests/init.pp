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
# \section{Unowned files and directories}
#
# \implements{macosxstig}{GEN001160 M6,GEN001170 M6}%
# Fix \emph{unowned} files and directories, defined as those whose numerical
# owner UID or group-owner GID do not map to a known user or group.
# 
# The check content of \macosxstig{GEN001160 M6} makes it clear that no unowned
# files or directories should exist anywhere on the system. But on any given
# UNIX workstation, some directories may be shared over a network, which makes
# the potential set of files to check not only uncomfortably large, but also
# redundant between hosts. Additionally, some of the shared directories may not
# be mounted in such a fashion that \verb!root! can change the owner or group
# of files and directories therein, so not all hosts could fix an unowned file
# or directory should they come across one.
#
# Accordingly the plan for making sure all files and directories are validly
# owned will vary between networks and between hosts. Classes in this module
# will take care of different parts of the namespace to provide the tools
# necessary for a complete defense against this threat.
