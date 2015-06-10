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
# \subsubsection{/etc/pki/tls}
#
# \implements{apachestig}{WG355 A22} Trust only DoD PKI CAs.
#
# These CA certificates will be used by web servers. Web servers should let ECA
# people in as well as CAC people.

class pki::ca_certs::tls {
    include pki
    file { "/etc/pki/tls":
        ensure => directory,
        owner => root, group => 0, mode => 0644,
    }
    file { "/etc/pki/tls/cacerts":
        ensure => directory,
        source => "puppet:///modules/pki/tls",
        recurse => true,
# We are copying files in a subdirectory---increase recurselimit.
        recurselimit => 2,
        ignore => ".svn",
        purge => true,
        owner => root, group => 0, mode => 0644,
    }
}
