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
# \subsubsection{Use System Security Services (SSS)}

class rhn_satellite::pam::sss {
    augeas { "rhn_satellite_pam_d":
        context => "/files/etc/pam.d/rhn-satellite",
        changes => [
            "rm *",
            "set 1/type    auth",
            "set 1/control required",
            "set 1/module  pam_env.so",
            "set 2/type    auth",
            "set 2/control sufficient",
            "set 2/module  pam_sss.so",
            "set 3/type    auth",
            "set 3/control required",
            "set 3/module  pam_deny.so",
            "set 4/type    account",
            "set 4/control sufficient",
            "set 4/module  pam_sss.so",
            "set 5/type    account",
            "set 5/control required",
            "set 5/module  pam_deny.so",
        ],
    }
}
