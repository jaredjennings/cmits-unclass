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
# \subsection{Random number generator}
#
# When in FIPS-compliant mode, OpenSSL uses \verb!/dev/random! for its
# randomness needs. This can be much slower without any decent sources of
# randomness, such as network packets, console keystrokes, etc., which a
# virtual machine may lack. The \verb!virtio-rng! module uses randomness from
# the host system in the virtual machine, improving the performance of
# \verb!/dev/random!.

class kvm::guest_random {
    if $virtual == "kvm" {
# See \cite{rhel6-deployment}, \S 22.6, ``Persistent Module Loading.''
        file { "/etc/sysconfig/modules/virtio-rng.modules":
            owner => root, group => 0, mode => 0755,
            content => "#!/bin/sh\nmodprobe virtio-rng\n",
        }
    }
}
