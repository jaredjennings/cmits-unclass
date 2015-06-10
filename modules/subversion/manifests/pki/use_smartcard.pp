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
# \subsubsection{Use CACs with Subversion}
#
# Allowing the use of smartcards with Subversion in this way is a
# systemwide setting, and commits this host to never using soft
# certificates to access a Subversion repository.
#
# Subversion 1.7 as shipped in RHEL6 looks both in systemwide
# configuration (\verb!/etc/subversion/servers!) and user-specific
# configuration (\verb!~/.subversion/servers!) for settings regarding
# a particular server it's communicating with. The user-specific
# configuration overrides the systemwide configuration, \emph{but} you
# can't unset something in user-specific configuration that was set in
# the systemwide configuration, only set it to a different value. And
# any value set for the {\tt ssl-pkcs11-provider} setting means soft
# certificate files will not be used, but instead a PKCS\#11 module
# will be sought. A failure to find a module so named is a failure to
# authenticate with a certificate. So if there is a systemwide default
# to use a PKCS\#11 provider, there is no setting that can be written
# in a user's \verb!~/.subversion/servers! that can make that user
# able to use soft certificates.
#
# A patch to the software could fix this, but such a patch would never
# enter the upstream software, because the Subversion project has
# already moved on to 1.8, which does not support PKCS\#11 at all. (See
# \url{http://subversion.apache.org/docs/release-notes/1.8.html#neon-deleted}
# and url{https://code.google.com/p/serf/issues/detail?id=27}.)

class subversion::pki::use_smartcard {

    include subversion::pki

    $pkcs11_provider = $::osfamily ? {
        'RedHat' => 'coolkey',
        'Darwin' => 'opensc-pkcs11',
        default  => unimplemented(),
    }

    require subversion::servers_config
    augeas { 'subversion_use_smartcard':
# By using the \verb![global]! section for these settings, we are telling
# Subversion that any Subversion server that asks for a client certificate
# wants the one from the user's CAC. Server groups could be used to make this
# more specific, but so far anyone who configures a Subversion server to use
# client certificates has been someone who wanted to use CACs with it.
        context => '/files/etc/subversion/servers/global',
        changes => [
            "set ssl-pkcs11-provider ${pkcs11_provider}",
        ],
	lens => 'Subversion.lns',
	incl => '/etc/subversion/servers',
    }
}
