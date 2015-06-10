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
# \section{SSH}
#
# See~\S\ref{class_hpcmp::openssh} for other SSH client-side configuration
# which may apply to some hosts.

class ssh {
    $configdir = $::osfamily ? {
        'RedHat' => '/etc/ssh',
        'Darwin' => '/etc',
        default  => unimplemented(),
    }
    $server_config = "${configdir}/sshd_config"
    $client_config = "${configdir}/ssh_config"

    $service_name = $::osfamily ? {
        'redhat' => 'sshd',
        'darwin' => 'com.openssh.sshd',
        default  => unimplemented(),
    }

    service { 'sshd':
        name => $service_name,
    }
}
