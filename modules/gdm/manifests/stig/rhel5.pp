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
# \subsubsection{Under RHEL5}

class gdm::stig::rhel5 {
# Make sure the file we're about to edit exists: if we have no custom options
# set yet, it won't.
    file { "/etc/gdm/custom.conf":
        ensure => present,
        owner => root, group => 0, mode => 0644,
    }
# \implements{rhel5stig}{GEN000000-LNX00360}%
# \implements{rhel5stig}{GEN000000-LNX00380} Set the right X server options
# (\verb!-s! [screensaver timeout], \verb!-audit! [audit level], and
# \verb!-auth! [authorization record file], which ``gdm always automatically
# uses''), and don't set the wrong ones (\verb!-ac! [disable host-based access
# control], \verb!-core! [dump core on fatal errors], and \verb!-nolock!
# [unknown, not in man page]). (The \verb!-br! option merely makes the screen
# black by default when the server starts up, instead of the gray weave
# pattern.)
    require augeas
    augeas { "gdm_servers_switches":
        require => File["/etc/gdm/custom.conf"],
        context => "/files/etc/gdm/custom.conf/server-Standard",
# Copied from Red Hat 5 STIG fix text.
        changes => [
            "set command '/usr/bin/Xorg -br -audit 4 -s 15'",
            "set name 'Standard server'",
            "set chooser false",
            "set handled true",
            "set flexible true",
            "set priority 0",
        ],
    }
}
