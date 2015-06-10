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
# \subsubsection{Maintain CRLs for TLS CA certificates}
#
# \implements{apachestig}{WG145 A22} Keep certificate revocation lists (CRLs) up
# to date.

class pki::tls::crl($http_proxy='') {

# The CRL updating script needs this.
    package { "python-ldap": ensure => present }

    file { "/etc/pki/tls/crls":
        ensure => directory,
        owner => root, group => 0, mode => 0644,
        recurse => true, recurselimit => 1,
    }

    file { "/usr/sbin/refresh_crls.py":
        owner => root, group => 0, mode => 0755,
        source => "puppet:///modules/pki/\
get_crl/refresh_crls.py",
    }

    file { "/etc/cron.daily/refresh_crls":
        owner => root, group => 0, mode => 0700,
        content => "#!/bin/sh\n\
export http_proxy=${http_proxy}\n\
/usr/sbin/refresh_crls.py \
  /etc/pki/tls/cacerts \
  /etc/pki/tls/crls\n",
    }
}
