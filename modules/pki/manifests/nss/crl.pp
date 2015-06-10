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
# \subsubsection{Maintain CRLs for NSS database}
#
# \implements{apachestig}{WG145 A22} Keep certificate revocation lists (CRLs) up
# to date.

define pki::nss::crl($dbdir, $pwfile, $http_proxy='', $sqlite=true) {
    file { "/usr/sbin/refresh_crls_nss.py":
        owner => root, group => 0, mode => 0755,
        source => "puppet:///modules/pki/\
get_crl/refresh_crls_nss.py",
    }

    $berkeley_switch = $sqlite ? {
        true  => '',
        false => '-B',
    }
    file { "/etc/cron.daily/refresh_nss_crls_${name}":
        owner => root, group => 0, mode => 0700,
        content => "#!/bin/sh
export http_proxy=${http_proxy}

/usr/sbin/refresh_crls_nss.py \
        ${berkeley_switch} ${dbdir} ${pwfile}
",
    }
}
