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
# \subsection{Secure skel files}

class stig_misc::skel {
# \implements{unixsrg}{GEN001800,GEN001820,GEN001830} Control ownership and
# permissions of skeleton files.
    file { "/etc/skel":
        owner => root, group => 0, mode => 0644,
        recurse => true, recurselimit => 8,
    }
# \implements{unixsrg}{GEN001810} Remove extended ACLs from skeleton files.
    no_ext_acl { "/etc/skel": recurse => true }
}
