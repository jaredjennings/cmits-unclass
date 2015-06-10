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
# \subsection{Disable NFS client}
#
# This class disables services that are needed both for NFS servers
# and for NFS clients.
#
# If you need your Macs to be NFS clients, do not include this class.

class nfs::client::no::darwin {
# \implements{mlionstig}{OSX8-00-00142}%
# Disable the NFS lock d\ae mon.
    service { 'com.apple.lockd':
        enable => false,
        ensure => stopped,
    }
# \implements{mlionstig}{OSX8-00-00143}%
# Disable the NFS stat d\ae mon.
    service { 'com.apple.statd':
        enable => false,
        ensure => stopped,
    }
}
