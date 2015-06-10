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
# \subsubsection{HPC Kerberos {\tt pkinit}}
#
# Install CA certs into the /etc/pki directory, where they will be used by
# the {\tt pkinit} utility from the HPCMP Kerberos distribution.
#
# {\tt pkinit} wants the root certificates and the CA certificates in different
# directories, so we put the root certificates in a \verb!root! subdirectory
# beside the CA certificates, in \verb!/etc/pki/dod!.

class pki::ca_certs::pkinit {
    include pki
    file { "/etc/pki/pkinit":
        ensure => directory,
        owner => root, group => 0, mode => 0644,
        source => "puppet:///modules/pki/pkinit",
        recurse => true,
# We are copying files in a subdirectory---increase recurselimit.
        recurselimit => 2,
        ignore => ".svn",
        purge => true,
    }
}
