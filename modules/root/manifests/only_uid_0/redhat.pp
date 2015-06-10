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
class root::only_uid_0::redhat {
# \implements{unixsrg}{GEN000880}%
# Make sure root is the only user with a user id of 0.
#
# Log an error if any account besides root has a user id of 0. Do this
# by finding all users with a uid of 0, ignoring root (using
# \verb!grep -v!). If any results remain to be printed, \verb!grep!
# will exit with 0 (success). Then the command will be executed and
# its output logged as errors. N.B. \verb!augtool match! does not
# reliably exit with any given exit code, so we must rely on grep
# here. See
# \url{http://www.redhat.com/archives/augeas-devel/2010-January/msg00100.html}.
    exec { "only_root_uid_0":
        onlyif =>
            "augtool match \
             /files/etc/passwd/\\*/uid[.=\\'0\\'] \
             | grep -v '^/files/etc/passwd/root/uid = 0'",
        command =>
            "augtool match \
             /files/etc/passwd/\\*/uid[.=\\'0\\'] \
             | grep -v '^/files/etc/passwd/root/uid = 0'",
        logoutput => true,
        loglevel => err,
        require => Class['augeas'],
    }
}
