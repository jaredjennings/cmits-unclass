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
# \subsection{TLS}
#
# Maintain certificates, keys, and CRLs needed for TLS (Transport Layer
# Security). These are used by web servers.

class pki::tls($http_proxy='') {
# Make sure the private TLS directory is actually private.
    file { "/etc/pki/tls/private":
        owner => root, group => 0, mode => 0600,
        recurse => true, recurselimit => 3,
    }
# This one has to be executable
    file { "/etc/pki/tls/private/.startup":
        owner => root, group => 0, mode => 0700,
    }

    include pki::ca_certs::tls
    class { 'pki::tls::crl':
        http_proxy => $http_proxy,
    }
}
