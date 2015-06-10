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
# \subsection{Enable GSSAPI authentication}
#
# Where GSSAPI authentication is needed, enable it.

class ssh::gssapi {
    include ssh
    augeas { "sshd_gssapi":
        context => "/files${ssh::server_config}",
        changes => [
# \implements{unixsrg}{GEN005524}%
# Disable GSSAPI authentication in the SSH server ``unless needed.'' In some
# cases we need it.
            "set GSSAPIAuthentication yes",
        ],
    }

# The \verb!/etc/ssh/ssh_config! file is parsed by a non-stock lens.
    require augeas

    augeas { "ssh_client_gssapi":
        context => "/files${ssh::client_config}/Host[.='*']",
        changes => [
# \implements{unixsrg}{GEN005525}%
# Disable GSSAPI authentication in the SSH client ``unless needed.'' In some
# cases we need it.
            "set GSSAPIAuthentication yes",
        ],
    }
}

