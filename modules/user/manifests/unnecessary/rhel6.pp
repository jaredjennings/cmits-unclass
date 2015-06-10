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
# On a freshly installed RHEL6 system, there exist files owned by the following users:
# % Oho, so smart, to columnize, but hard to edit...
# \begin{verbatim}
# abrt         lp          rpc
# apache       ntp         rpcuser
# avahi        postfix     tss
# daemon       pulse       vcsa
# gdm          puppet
# haldaemon    root
# \end{verbatim}
#
# The following users, then, do not own any files:
# \begin{verbatim}
# bin         uucp        rtkit
# adm         games       saslauth
# sync        gopher      sshd
# shutdown    ftp         tcpdump
# halt        nobody      nfsnobody
# mail        dbus
# \end{verbatim}
#
# The system users not owning any files, listed above, are mostly associated
# with system processes;
# \bydefault{RHEL6}{unixsrg}{GEN000280}%
# they are disabled from logging in by default.
#
# The full list of possible system users under RHEL6 can be found in the
# Deployment Guide \cite{rhel6-deployment}, \S 3.3. A user from that list is
# added when the package requiring the user is installed, so
# \bydefault{RHEL6}{unixsrg}{GEN000290}%
# application accounts do not exist for applications not installed on the
# system. Policy regarding user accounts for people, including ensuring that
# people who aren't going to use a host are not added as users of that host, is
# dealt with in other subsections of \S\ref{module_user}.

class user::unnecessary::rhel6 {
    
# \implements{rhel5stig}{GEN000000-LNX00320}%
# Remove the \verb!shutdown!, \verb!halt!  and \verb!reboot! user accounts. The
# requirement says ``special privilege accounts'' must be removed, but only
# mentions these three.
    user { ["shutdown", "halt", "reboot"]:
        ensure => absent,
    }
#
# \implements{unixsrg}{GEN000290}%
# Some system users are installed by the \verb!setup! package, but not
# subsequently used. Remove them.
#
# Not least to make pwck happy: their home directories seem not to usually
# exist. 
    user { ["adm", "uucp", "gopher"]:
        ensure => absent,
    }
# This user is listed as belonging to the \verb!cyrus-imapd! package; we don't
# run IMAP servers.
    user { "saslauth":
        ensure => absent,
    }

    if($gdm_installed == 'false') {
        user { "gdm":
            ensure => absent,
        }
    }
}
