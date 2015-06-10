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
# \section{Citrix Receiver ICA client}
#
# Some users may require access to the Citrix XenApp server via the
# Citrix Receiver ICA client.
#
# The ICAClient package is not part of RHEL: it must be fetched from
# Citrix. But the package fetched from Citrix is signed using the MD5
# digest algorithm, and so will not install on a host configured for
# FIPS 140-2 compliance (see~\S\ref{module_fips}). So we have a custom
# package, the same in every salient respect except that it is signed
# using SHA256.

class citrix_ica {
    case $::osfamily {
        'RedHat': {
            package { 'ICAClient':
                ensure => '12.1.0.203066-1SK02',
            }
            mozilla::wrap_32bit { 'npica.so':
                require => Package['ICAClient'],
            }
        }
        'Darwin': { warning("citrix_ica not yet implemented on Macs") }
        default: { unimplemented() }
    }
    include pki::ca_certs::citrix_receiver
}
