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
# \subsubsection{Make Subversion trust the DoD PKI}

class subversion::pki::trust_cas {
# Make sure the CA certs are somewhere we expect.
    include pki::ca_certs::tls

    require subversion::servers_config
    augeas { 'subversion_root_ca':
        context => '/files/etc/subversion/servers/global',
        changes => [
# If you add more \verb!ssl-authority-files!, they should be delimited by
# semicolons, with no spaces in between them.
            "set ssl-authority-files \
/etc/pki/tls/cacerts/DoD-Root2-Root.crt",
	lens => 'Subversion.lns',
	incl => '/etc/subversion/servers',
        ],
    }
}
