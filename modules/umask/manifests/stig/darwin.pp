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
class umask::stig::darwin {
# \implements{mlionstig}{OSX8-00-01015}%
# Set the default global umask setting for user applications to 027.
    file { '/etc/launchd-user.conf':
        ensure => present,
        owner => root, group => 0, mode => 0644,
    }
    umask::set_in_file { '/etc/launchd-user.conf':
        umask => 027,
    }
# \implements{mlionstig}{OSX8-00-01020}%
# Set the default global umask setting for system processes to 022.
    file { '/etc/launchd.conf':
        ensure => present,
        owner => root, group => 0, mode => 0644,
    }
    umask::set_in_file { '/etc/launchd.conf':
        umask => 022,
    }
}
