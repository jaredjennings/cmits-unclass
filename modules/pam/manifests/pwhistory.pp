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
class pam::pwhistory {
# Use the pam\_pwhistory module to make sure passwords are not reused within
# the last ten changes. First, make sure there is a line in the right place
# calling pam\_pwhistory:
    augeas { "system_auth_pwhistory":
        require => Augeas["system_auth_cracklib"],
        context => "/files/etc/pam.d/system-auth",
        changes => [
            "rm *[type='password'][module='pam_pwhistory.so']",
            "ins 100 after *[type='password']\
[module='pam_cracklib.so' or module='pam_centrifydc.so'][last()]",
            "set 100/type password",
            "set 100/control requisite",
            "set 100/module pam_pwhistory.so",
# \implements{unixsrg}{GEN000800}%
# Remember the last ten passwords and prohibit their reuse.
            "set 100/argument[1] remember=10",
# Do this even for root.
            "set 100/argument[2] enforce_for_root",
# Don't prompt for another password: use the one from the module above this
# one.
            "set 100/argument[3] use_authtok",
            ],
    }
}
