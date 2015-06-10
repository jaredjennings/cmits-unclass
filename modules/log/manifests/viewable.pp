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
# \subsection{Make logs viewable by the logview user}
#
# Concept of operations: A log viewing host has an automatic graphical login to
# the logview user. This host has no input devices, only monitors. On this host
# resides logview's private SSH key. Part of the session startup is to start an
# xterm with an ssh in it; the ssh connects to the loghost and runs a
# log-tailing command. To mitigate the risk of having a private key with no
# passphrase protecting it, we make sure that the key is only usable on the
# loghost to run the log-tailing command, not any arbitrary command. Rather
# than making the log files available to the unprivileged logview user for
# reading, we make logview sudo in order to read them.
#
# Apparently, obtaining a pty and using a command-limited SSH key are two
# things that OpenSSH does not support at the same time. So we have to
# reconfigure sudo such that for this user it will allow sudoing without a tty.
# The {\tt sudoers(5)} man page seems to imply that the {\tt requiretty} option
# exists to make sure that people use sudo and not scripts, by compelling its
# use from a login session. The stock {\tt /etc/sudoers} file says in its
# comments that the reason to require a tty is so that sudo can suppress the
# display of the password as it is typed. In this case we want to enable sudo
# to be used by a script (limited to one command, tailing the system log), and
# logview does not use a password to sudo, so a password cannot be accidentally
# shown. With the risks of not requiring a tty suitably mitigated, we proceed
# cheerfully.

class log::viewable($ssh_public_key) {
    Group <| title == "logview" |>
    User <| title == "logview" |>

    file { "/usr/local/sbin/tail-messages":
        owner => root, group => 0, mode => 0755,
        content => "#!/bin/sh\n\
sudo /usr/bin/tail -f /var/log/messages\n",
    }

    file { "/etc/sudoers.d/logview":
        owner => root, group => 0, mode => 0440,
        content => "Defaults:logview !requiretty\n\
logview ALL=(ALL) \
        NOPASSWD:/usr/bin/tail -f /var/log/messages\n",
    }

    ssh_authorized_key {
        "logview":
            require => [
                File["/home/logview"],
                File["/usr/local/sbin/tail-messages"],
            ],
            user => "logview",
            type => "ssh-dss",
            name => "logview@bla",
            options => ['command="/usr/local/sbin/tail-messages"'],
            key => $ssh_public_key,
    }
}
