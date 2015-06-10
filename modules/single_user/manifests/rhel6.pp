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
# \subsection{Securing single-user mode under RHEL6}
#
# RHEL6 uses Upstart as its init.

class single_user::rhel6 {
    augeas { "single_user":
        context => "/files/etc/sysconfig/init",
        changes => [
# \implements{unixsrg}{GEN000020} Require authentication for access to
# single-user mode.
            "set SINGLE /sbin/sulogin",
# As interactive startup (opportunity to say whether each service will start)
# seems like a ``maintenance mode,'' we'll disable it here.
                "set PROMPT no",
        ],
    }
}
