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
class pam::cracklib {
# \implements{unixsrg}{GEN000790}%
# Enforce password guessability guidelines using the {\tt pam\_cracklib}
# module. This module first tries to look the password up in a dictionary using
# {\tt cracklib}, then applies strength checks as directed.
    augeas { "system_auth_cracklib":
        context => "/files/etc/pam.d/system-auth",
        changes => [
            "rm *[type='password'][module='pam_cracklib.so']",
            "ins 100 before *[type='password' and module!='pam_centrifydc.so'][1]",
            "set 100/type password",
            "set 100/control requisite",
            "set 100/module pam_cracklib.so",
# \implements{unixsrg}{GEN000580}%
# Require a minimum password length of 14 characters.
            "set 100/argument[1] minlen=14",
# \implements{unixsrg}{GEN000600}%
# Require passwords to contain at least one uppercase letter.
            "set 100/argument[2] ucredit=-1",
# \implements{unixsrg}{GEN000610}%
# Require passwords to contain at least one lowercase letter.
            "set 100/argument[3] lcredit=-1",
# \implements{unixsrg}{GEN000620}%
# Require passwords to contain at least one digit.
            "set 100/argument[4] dcredit=-1",
# \implements{unixsrg}{GEN000640}%
# Require passwords to contain at least one other (special) character.
            "set 100/argument[5] ocredit=-1",
# Prevent users from using parts of their usernames in their passwords.
#
# (This and a few other things were GEN000660 in the 2006 UNIX STIG.)
            "set 100/argument[6] reject_username",
# \implements{unixsrg}{GEN000680}%
# Prohibit the repetition of a single character in a password more than three
# times in a row.
            "set 100/argument[7] maxrepeat=3",
# Let the user have three attempts at entering a strong password.
            "set 100/argument[8] retry=3",
# \implements{unixsrg}{GEN000750}%
# Require that at least four characters be changed between the old and new
# passwords.
#
# (When changing this setting, see the man page for \verb!pam_cracklib!: the
# exact semantics of the difok parameter are slightly different from the
# semantics of the STIG requirement.)
            "set 100/argument[9] difok=4",
            ],
    }
}
