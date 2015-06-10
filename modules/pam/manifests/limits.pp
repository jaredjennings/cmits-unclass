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
# \subsection{pam\_limits}
#
# Make sure that \verb!pam_limits.so! is called by the PAM configuration.

class pam::limits {
    augeas {
        "pam_limits_insert":
            context => "/files/etc/pam.d/system-auth",
            onlyif => "match *[type='session' and \
                               module='pam_limits.so'] \
                       size == 0",
            changes => [
                "insert 999 before *[type='session' and module!='pam_centrifydc.so'][1]",
                "set 999/type session",
                "set 999/control required",
                "set 999/module pam_limits.so",
            ];
        "pam_limits_require":
            require => Augeas["pam_limits_insert"],
            context => "/files/etc/pam.d/system-auth",
            changes => "set *[\
                    type='session' and \
                    module='pam_limits.so']/control \
                required";
    }
}
