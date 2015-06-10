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
# \subsection{Install DoD root cert(s)}
#
# This defined resource type will install DoD root CA certificates (no
# intermediate CAs, no ECAs) into the named database.

define pki::nss::dod_roots($pwfile='', $sqlite=true) {
    nss_cert { "${name}:DoD-Root2-Root":
        source => "puppet:///modules/pki/all-ca-certs/",
        trustargs => 'CT,C,C',
        pwfile => $pwfile,
        require => Pki::Nss::Db[$name],
        sqlite => $sqlite,
    }
}
