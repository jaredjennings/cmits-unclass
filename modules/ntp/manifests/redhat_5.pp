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
class ntp::redhat_5 {
    package { 'ntp':
        ensure => present,
    }
    service { 'ntpd':
        enable => true,
        ensure => running,
    }

# \implements{unixsrg}{GEN000250,GEN000251,GEN000252} Control ownership and
# permissions of the \verb!ntp.conf! file.
    file { "/etc/ntp.conf":
        owner => root, group => 0, mode => 0640,
    }
# \implements{unixsrg}{GEN000253} Remove extended ACLs on the \verb!ntp.conf!
# file.
    no_ext_acl { "/etc/ntp.conf": }
}
