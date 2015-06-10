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
# \subsection{FIPS 140-2-required SSH configuration}

class ssh::fips {
    include ssh

    augeas { "sshd_fips":
        context => "/files${ssh::server_config}",
        changes => [
# \implements{unixsrg}{GEN005500}%
# \implements{macosxstig}{OSX00175 M6}%
# \implements{mlionstig}{OSX8-00-00570,OSX8-00-00575}%
# Configure the SSH server to reject SSH protocol version 1, which is no longer
# secure.
            "set Protocol 2",
# \implements{macosxstig}{GEN005505 M6}%
# \implements{unixsrg}{GEN005505}%
# Configure the SSH server to use only FIPS 140-2 \cite{fips-140-2} approved
# ciphers.
#
# According to the SRG, this presently means 3DES and AES.
#
# \implements{macosxstig}{GEN005506 M6}%
# \implements{unixsrg}{GEN005506}%
# Disable use of the cipher-block chaining (CBC) mode in the SSH server.
#
# (See \url{http://openssh.com/txt/cbc.adv}.)
            "set Ciphers aes128-ctr,aes192-ctr,aes256-ctr",
# \implements{macosxstig}{GEN005507 M6}%
# \implements{unixsrg}{GEN005507}%
# Configure the SSH server to use only FIPS 140-2 approved message
# authentication code (MAC) hash algorithms.
#
# According to the man page, the only one that looks good is \verb!hmac-sha1!.
# Maybe with HMAC MD5 can be OK, but we won't chance it.
            "rm MACs",
            "set MACs/1 hmac-sha1",
        ],
        notify => Service["sshd"],
    }

# The \verb!/etc/ssh/ssh_config! file is parsed by a non-stock lens.
    require augeas

    augeas { "ssh_client_fips":
        context => "/files${ssh::client_config}/Host[.='*']",
        changes => [
# \implements{unixsrg}{GEN005501}%
# Configure the SSH client not to use SSH protocol version 1, which is no
# longer secure.
            "set Protocol 2",
# \implements{macosxstig}{GEN005510 M6}%
# \implements{unixsrg}{GEN005510}%
# Configure the SSH client to use only FIPS 140-2 approved ciphers.
#
# \implements{macosxstig}{GEN005511 M6}%
# \implements{unixsrg}{GEN005511}%
# Disable use of CBC mode by the SSH client.
            "rm Ciphers",
            "set Ciphers/1 aes256-ctr",
            "set Ciphers/2 aes192-ctr",
            "set Ciphers/3 aes128-ctr",
# \implements{macosxstig}{GEN005512 M6}%
# \implements{unixsrg}{GEN005512}%
# Configure the SSH client to use only FIPS 140-2 approved MAC hash algorithms.
#
# (The \verb!sshd_config! lens makes the \verb!MACs! setting a tree; the
# CMITS-custom \verb!ssh_config! lens does not treat it specially. That is why
# this section differs from that above.)
            "rm MACs",
            "set MACs/1 hmac-sha1",
        ],
    }

# If a host has FIPS compatibility configured before the sshd is first started,
# the sshd init script will try to generate an SSH version 1 RSA host key, and
# fail. We don't use SSH version 1, so that key need not be made; but the
# script must be changed in order not to make it, otherwise it will never
# progress beyond that failure to the part where the sshd actually gets
# started.

    $has_rsa1_keygen_regex =
            '^[[:space:]]*do_rsa1_keygen[[:space:]]*$'
    exec { "sshd_no_version1_keygen":
        path => ['/bin', '/usr/bin'],
        command => "sed -i \
            -e '/${has_rsa1_keygen_regex}/d' \
            /etc/init.d/sshd",
        onlyif => "grep \
            '${has_rsa1_keygen_regex}' \
            /etc/init.d/sshd",
        notify => Service["sshd"],
    }
}
