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
# \subsubsection{libpurple (Pidgin)}
#
# Install CA certs into the /usr/share/purple/ca-certs directory, where they
# will be used by instant messaging clients that use the {\tt libpurple}
# library.

class pki::ca_certs::libpurple {
    # This method seems janky.
    define install() {
        $cacerts = $::osfamily ? {
            'RedHat' => '/usr/share/purple/ca-certs',
            default  => unimplemented(),
        }
        file { "$cacerts/$name":
            owner => root, group => 0, mode => 0444,
            source => "puppet:///modules/pki/all-ca-certs/$name",
            require => Package['libpurple'],
        }
    }
    define remove() {
        $cacerts = $::osfamily ? {
            'RedHat' => '/usr/share/purple/ca-certs',
            default  => unimplemented(),
        }
        file { "$cacerts/$name":
            ensure => absent,
            require => Package['libpurple'],
        }
    }
    install { [
            'DoD-email-Root2-CA21.crt',
            'DoD-email-Root2-CA22.crt',
            'DoD-email-Root2-CA23.crt',
            'DoD-email-Root2-CA24.crt',
            'DoD-email-Root2-CA25.crt',
            'DoD-email-Root2-CA26.crt',
            'DoD-email-Root2-CA27.crt',
            'DoD-email-Root2-CA28.crt',
            'DoD-email-Root2-CA29.crt',
            'DoD-email-Root2-CA30.crt',
            'DoD-Root2-CA21.crt',
            'DoD-Root2-CA22.crt',
            'DoD-Root2-CA23.crt',
            'DoD-Root2-CA24.crt',
            'DoD-Root2-CA25.crt',
            'DoD-Root2-CA26.crt',
            'DoD-Root2-CA27.crt',
            'DoD-Root2-CA28.crt',
            'DoD-Root2-CA29.crt',
            'DoD-Root2-CA30.crt',
            'DoD-Root2-Root.crt',
            'ECA-IdenTrust3.crt',
            'ECA-ORC-HW4.crt',
            'ECA-ORC-SW4.crt',
            'ECA-Root2.crt',
            'ECA-Root.crt',
            'ECA-Verisign-G3.crt',
        ]: }
    remove { [
            'DoD-Class3-Root.crt',
            'DoD-email-Root2-CA15.crt',
            'DoD-email-Root2-CA16.crt',
            'DoD-email-Root2-CA17.crt',
            'DoD-email-Root2-CA18.crt',
            'DoD-email-Root2-CA19.crt',
            'DoD-email-Root2-CA20.crt',
            'DoD-Root2-CA15.crt',
            'DoD-Root2-CA16.crt',
            'DoD-Root2-CA17.crt',
            'DoD-Root2-CA18.crt',
            'DoD-Root2-CA19.crt',
            'DoD-Root2-CA20.crt',
            'ECA-IdenTrust2.crt',
            'ECA-Verisign-G2.crt',
            'ECA-ORC-HW3.crt',
            'ECA-ORC-SW3.crt',
        ]: }
}
