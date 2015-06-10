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
# \section{PKI (Public Key Infrastructure)}
# \label{pki}
#
# Configure PKI-related parts of the system. These have to do with
# certification authority (CA) certificates, certificate revocation lists
# (CRLs) and the like.

class pki {
    file { '/etc/pki':
        ensure => directory,
        owner => root, group => 0, mode => 0644,
    }
}
