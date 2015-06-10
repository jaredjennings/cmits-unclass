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
# \subsubsection{Under RHEL6}
#
# \unimplemented{rhel5stig}{GEN000000-LNX00360,GEN000000-LNX00380}{GDM X server
# startup requirements appear to be unimplementable under RHEL6.}
#
# RHEL 6 contains \verb!gdm! 2.30. At \verb!2.22!, GDM was rewritten, and no
# longer pays attention to the server-startup-related sections of
# \verb!/etc/gdm/custom.conf!. See
# \url{https://bugzilla.redhat.com/show_bug.cgi?id=452528},
# \url{http://live.gnome.org/GDM/2.22/Configuration}. It appears that the
# command-line switches \verb!-br -verbose! are hard-coded into
# \verb!/usr/libexec/gdm-simple-slave!.
#
# I have filed RHBZ 773111 about this.
# \url{https://bugzilla.redhat.com/show_bug.cgi?id=773111}

class gdm::stig::rhel6 {}

