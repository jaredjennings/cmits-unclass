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
# \subsection{Install DoD CA certs}
#
# This defined resource type will install DoD CA certificates (not email CAs,
# not ECAs) into the named NSS database.
define pki::nss::dod_cas($pwfile='', $sqlite=true) {
    Nss_cert {
        source => "puppet:///modules/pki/all-ca-certs/",
        pwfile => $pwfile,
        sqlite => $sqlite,
        require => [
            Pki::Nss::Db[$name],
            Nss_cert["${name}:DoD-Root2-Root"],
        ],
    }

    nss_cert {
        "${name}:DoD-Root2-CA21":;
        "${name}:DoD-Root2-CA22":;
        "${name}:DoD-Root2-CA23":;
        "${name}:DoD-Root2-CA24":;
        "${name}:DoD-Root2-CA25":;
        "${name}:DoD-Root2-CA26":;
        "${name}:DoD-Root2-CA27":;
        "${name}:DoD-Root2-CA28":;
        "${name}:DoD-Root2-CA29":;
        "${name}:DoD-Root2-CA30":;
        "${name}:DoD-Root2-CA31":;
        "${name}:DoD-Root2-CA32":;
    }

# Remove expired CA certs.
    nss_cert {
        "${name}:DoD-Root2-CA11": ensure => absent;
        "${name}:DoD-Root2-CA12": ensure => absent;
        "${name}:DoD-Root2-CA13": ensure => absent;
        "${name}:DoD-Root2-CA14": ensure => absent;
        "${name}:DoD-Root2-CA15": ensure => absent;
        "${name}:DoD-Root2-CA16": ensure => absent;
        "${name}:DoD-Root2-CA17": ensure => absent;
        "${name}:DoD-Root2-CA18": ensure => absent;
        "${name}:DoD-Root2-CA19": ensure => absent;
        "${name}:DoD-Root2-CA20": ensure => absent;
    }
}
