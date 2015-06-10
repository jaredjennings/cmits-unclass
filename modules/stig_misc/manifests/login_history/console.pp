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
# \subsubsection{At the console}
#
# For this we use \verb!pam_lastlog.so!.

class stig_misc::login_history::console {
# First make sure that \verb!pam_lastlog! is called by the PAM configuration.
    augeas { "pam_lastlog_insert":
        context => "/files/etc/pam.d/system-auth",
        onlyif => "match *[type='session' and \
                           module='pam_lastlog.so'] \
                   size == 0",
        changes => [
            "insert 999 after *[type='session'][last()]",
            "set 999/type session",
            "set 999/control required",
            "set 999/module pam_lastlog.so",
        ],
    }
# Now---set its parameters.
    augeas { "pam_lastlog_parameters":
        context => "/files/etc/pam.d/system-auth/*[\
                 type='session' and \
                 module='pam_lastlog.so']",
        changes => [
            "rm argument",
            "set argument showfailed",
        ]
    }
}
