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
# \subsection{Set login failure delay}

class pam::faildelay($seconds) {

# The delay argument is in microseconds, so we convert.
    $microseconds = $seconds * 1000000

    augeas { "pam_faildelay":
        context => "/files/etc/pam.d/system-auth",
        changes => [
            "rm *[type='auth'][module='pam_faildelay.so']",
            "insert 999 before *[type='auth' and module!='pam_centrifydc.so'][1]",
            "set 999/type auth",
            "set 999/control required",
            "set 999/module pam_faildelay.so",
            "set 999/argument delay=$microseconds",
        ],
    }
}
