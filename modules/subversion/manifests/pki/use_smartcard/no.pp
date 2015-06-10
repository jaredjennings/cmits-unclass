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
# \subsubsection{Don't necessarily use CACs with Subversion}
#
# This removes the systemwide default to use smartcards with
# Subversion, to enable a use case where some users on a host have
# soft certificates. On such a host, users who wish to use their
# smartcards with Subversion must write a setting for
# \verb!ssl-pkcs11-provider! in their \verb!~/.subversion/servers!
# file.

class subversion::pki::use_smartcard::no {

    include subversion::pki

    require subversion::servers_config
    augeas { 'subversion_use_smartcard':
        context => '/files/etc/subversion/servers/global',
        changes => [
            "rm ssl-pkcs11-provider",
        ],
	lens => 'Subversion.lns',
	incl => '/etc/subversion/servers',
    }
}
