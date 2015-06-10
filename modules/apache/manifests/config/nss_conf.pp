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
class apache::config::nss_conf($nss_database_dir) {
    include apache

    if $::osfamily != 'RedHat' or $operatingsystemrelease !~ /^6\./ {
        unimplemented()
    }

    $nss_sites_dir = '/etc/httpd/nss-site.d'
    $rel_nss_sites_dir = 'nss-site.d'
    $abbr_ehcnc  = '/etc/httpd/conf.d/nss.conf'
    $abbr_fehcnc = "/files/${abbr_ehcnc}"

    Augeas {
        incl => $abbr_ehcnc,
        lens => 'Httpd.lns',
        notify => Service['httpd'],
    }

# Ensure a directive is in place and set to a given value, in the
# toplevel of nss.conf.
    define toplevel_directive($arguments) {
        $abbr_ehcnc = $apache::config::nss_conf::abbr_ehcnc
        directive { "${abbr_ehcnc}:${name}":
            context_in_file => "",
            arguments => $arguments,
        }
    }

    toplevel_directive {
# \implements{apachestig}{WA00555 A22} Listen on a specific IP
# address, so that if interfaces are added in the future we will not
# accidentally serve web pages on them by default.
        'Listen':
            arguments => ["${::ipaddress}:443"];
        'NSSPassPhraseDialog':
            arguments => ["file:${nss_database_dir}/pwfile"];
    }

# We are going to move the virtual host section to its own config
# file.
    augeas { 'remove stock virtualhost from nss.conf':
        incl => $abbr_ehcnc,
        lens => 'Httpd.lns',
        context => $abbr_fehcnc,
        changes => 'rm VirtualHost[arg="_default_:8443"]',
    }
    file { $nss_sites_dir:
        ensure => directory,
        owner => root, group => 0, mode => 0600,
    } ->
    toplevel_directive {
        'Include': arguments => ["${rel_nss_sites_dir}/*.conf"];
    }
}
