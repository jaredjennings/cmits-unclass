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
# \subsubsection{Systemwide NSS (/etc/pki/nssdb)}
#
# Install CA certs into the systemwide NSS database.

class pki::ca_certs::system_nss {
    $db = "/etc/pki/nssdb"
    pki::nss::db { $db:
        owner => root, group => 0, mode => 0644,
    }
    pki::nss::dod_roots { $db: }
    pki::nss::dod_cas { $db: }
    pki::nss::dod_email_cas { $db: }
    pki::nss::eca_roots { $db: }
    pki::nss::eca_cas { $db: }
}
