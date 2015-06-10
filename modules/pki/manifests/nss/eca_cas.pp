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
# \subsection{Install ECA CA cert(s)}
#
# This defined resource type will install CA certificates for External
# Certification Authorities (ECAs) into the named NSS database.

define pki::nss::eca_cas($pwfile='', $sqlite=true) {
    Nss_cert {
        source => "puppet:///modules/pki/all-ca-certs/",
        pwfile => $pwfile,
        sqlite => $sqlite,
        require => [
            Pki::Nss::Db[$name],
            Nss_cert["${name}:ECA-Root2"],
        ],
    }
    nss_cert {
#
# CA certs issued by the ECA Root CA: None seem to exist any more.
#
        "${name}:ECA-ORC2":
            ensure => absent;
        "${name}:ECA-Identitrust1":
            ensure => absent;
#
# CA certs issued by ECA Root CA 2:
#
        "${name}:ECA-Verisign-G2":
            ensure => absent;
        "${name}:ECA-IdenTrust2":
            ensure => absent;
        "${name}:ECA-ORC-HW3":
            ensure => absent;
        "${name}:ECA-ORC-SW3":
            ensure => absent;
        "${name}:ECA-ORC-HW4":;
        "${name}:ECA-ORC-SW4":;
        "${name}:ECA-IdenTrust3":;
        "${name}:ECA-IdenTrust4":;
        "${name}:ECA-Verisign-G3":;
    }
}
