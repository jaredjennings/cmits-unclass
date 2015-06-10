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
# \subsection{Disable kernel dumping}
#
# \implements{macosxstig}{GEN003510 M6}%
# \implements{mlionstig}{OSX8-00-01105}%
# \implements{unixsrg}{GEN003510}%
# \implements{iacontrol}{DCSS-1}%
# \notapplicable{unixsrg}{GEN003520,GEN003521,GEN003522,GEN003523}%
# Disable kernel core dumping to improve the security of the system during
# aborts: Kernel core dump files will contain sensitive data, and heretofore we
# have not needed to debug crashed kernels.

class kernel_core::no {
    case $::osfamily {
        'redhat': {
            service { 'kdump': 
                enable => false,
                ensure => stopped,
            }
        }
        'darwin': {
            augeas { 'sysctl_kern_coredump_off':
                context => '/files/etc/sysctl.conf',
                changes => 'set kern.coredump 0',
            }
        }
        default:  { unimplemented() }
    }
}
