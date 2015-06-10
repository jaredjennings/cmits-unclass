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
class pam::tally2 {

# \implements{unixsrg}{GEN000460}%
# Lock users out after three bad login attempts.
#
# We use the pam\_tally2 module for this. It's noteworthy that due to where we
# put this module in the stack, if smartcard login is enabled and the user
# presents a valid smartcard and PIN, she is logged in regardless of tally
# count. The reason for this is that the \verb!pam_tally2! module needs to know
# a username, but in the smartcard case, the \verb!pam_pkcs11! module is
# finding that username out---and if it succeeds, the rest of the stack is
# bypassed, including \verb!pam_tally2!. If \verb!pam_tally2! were put first,
# the user would have to enter a username before being prompted for a PIN. In
# terms of total system risk, the requirement to lock out users after three bad
# attempts is made in the context of passwords, and this policy works in the
# context of passwords; in the context of smartcards, the card itself will lock
# after three bad PIN attempts. Either of these taken alone meets the security
# requirement; there should not be many hosts accepting both passwords and CACs
# for authentication of normal users.

    augeas { "system_auth_tally2":
        context => "/files/etc/pam.d/system-auth",
        changes => [
            "rm *[module='pam_tally2.so'][type='auth']",
            "ins 100 before *[module='pam_deny.so' and type='auth']",
            "set 100/type auth",
            "set 100/control required",
            "set 100/module pam_tally2.so",
            "set 100/argument deny=3",
            "set 100/argument[2] audit",
            ],
    }
}
