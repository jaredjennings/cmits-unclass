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
# \subsubsection{Citrix Receiver ICA clients}
#
# Install CA certs into the proper directory where they can be used by the
# Citrix Receiver ICA client.
#
# It appears that the ICA client only needs the root certificate.

class pki::ca_certs::citrix_receiver {
    define install($cacerts) {
        file { "$cacerts/$name":
            owner => root, group => 0, mode => 0444,
            source => "puppet:///modules/pki/all-ca-certs/$name",
        }
    }
    case $::osfamily {
        'RedHat': {
            install { 'DoD-Root2-Root.crt':
                cacerts => '/opt/Citrix/ICAClient/keystore/cacerts',
            }
        }
        default: {
            notify { "unimplemented on $::osfamily": }
        }
    }
}
