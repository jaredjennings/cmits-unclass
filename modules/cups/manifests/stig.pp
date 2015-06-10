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
# \subsection{STIG-required printing configuration}
#
# The SRG requirements pertain to the \verb!hosts.lpd! file. CUPS does not use
# such a file. The means by which the administrator tells CUPS from what hosts
# to accept print jobs is the file \verb!/etc/cups/cupsd.conf!.
#
# \bydefault{RHEL5, RHEL6}{unixsrg}{GEN003900}%
# Under RHEL, the Common UNIX Printing System (CUPS) is configured by default
# only to listen to \verb!localhost!.

class cups::stig {

# First, make sure CUPS is installed and running.
    include "cups::${::osfamily}"

# \implements{unixsrg}{GEN003920,GEN003930,GEN003940}%
# Control ownership and permissions of the ``hosts.lpd (or equivalent) file,''
# in our case \verb!cupsd.conf!.
#
# (This file has mode \verb!0640! by default, which is less permissive than the
# required \verb!0664!.)
    file { "/etc/cups/cupsd.conf":
        owner => root, group => 0, mode => 0640,
    }
# \implements{unixsrg}{GEN003950}%
# Remove extended ACLs on the same file.
    no_ext_acl { "/etc/cups/cupsd.conf": }
}
