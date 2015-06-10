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
# \section{Apache httpd}
#
# Configure the Apache web server in accordance with the Apache STIG
# \cite{apache-server-stig}~\cite{apache-site-stig}.
#
# Most of the requirements involve the Apache configuration. We don't have
# enough distinct web servers that imposing the configuration items by means of
# a Puppet policy would be expedient. So the STIG requirements are noted in
# each web server's configuration; all those configurations are
# version-tracked.
#
# Requirements best fulfilled by Puppet policy are written and documented here.

class apache($production=true) {
    package { "httpd":
        ensure => present,
    }
    service { 'httpd':
        enable => true,
        ensure => running,
        require => Package['httpd'],
    }
    include apache::fips
    case $production {
        'false', false: { include apache::stig::nonproduction }
        default: { include apache::stig::production }
    }
}
