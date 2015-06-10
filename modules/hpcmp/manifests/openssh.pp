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
# \subsection{OpenSSH}
#
# Configuration necessary to connect to an HPCMP-administered cluster.
#
# The parameter \verb!hpc_cluster_host_patterns! is one or a list of host
# patterns as defined in \verb!ssh_config(1)!, to which client-side SSH
# settings will apply. The host patterns should match any HPCMP cluster login
# node, but should not match local hosts.

class hpcmp::openssh($hpc_cluster_host_patterns) {
    include hpcmp::kerberos
    include "hpcmp::openssh::${::osfamily}"

# This define implements for a set of hosts some of the settings Vern Staats
# set out on 1 May 2012. In the original configuration they are applied to all
# hosts. But we may need different settings, and so these settings should only
# apply when connecting to an HPCMP cluster.
#
# Some of the original configurations Vern specified are now part of the
# \verb!ssh::fips! class, \S\ref{class_ssh::fips}, and so are not written here.

    define vrs_settings() {
        require augeas
        augeas { "hpcmp_ssh_config_add_${name}":
            context => "/files${ssh::client_config}",
            onlyif =>
"match Host[.='${name}'] size == 0",
            changes => [
                "set Host[999] '${name}'",
            ],
        }

        augeas { "hpcmp_ssh_config_config_${name}":
            require => [
                Augeas["hpcmp_ssh_config_add_${name}"],
                Package['hpc_ossh'],
                ],
            context =>
"/files${ssh::client_config}/Host[.='${name}']",
            changes => [
                'set GSSAPIAuthentication yes',
                'set GSSAPIDelegateCredentials yes',
                'set GSSAPIKeyExchange yes',
                'set GSSAPIRenewalForcesRekey yes',
                "set PreferredAuthentications \
gssapi-with-mic,external-keyx,publickey,\
hostbased,keyboard-interactive,password",
                'set ForwardX11 yes',
                'set ForwardX11Trusted no',
# The Unix SRG prevents us from using SSH forwarding everywhere
# (see~\S\ref{class_ssh::no_tunnelling}), but for HPCMP clusters we need it,
# and apparently the HPCMP has accepted the risk, because their distribution of
# OpenSSH comes with it enabled. So un-disable it when talking to HPCMP
# clusters.
                'set ClearAllForwardings no',
# Get rid of some settings, which when implemented here cause ssh to groan and
# fail.
                'rm NoneEnabled',
                'rm MaxSessions',
                'rm XAuthLocation',
                'rm TcpRcvBuf',
                'rm TcpRcvBufPoll',
                'rm UMask',
            ],
        }
    }

    vrs_settings { $hpc_cluster_host_patterns: }
}
