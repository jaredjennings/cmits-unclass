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
# \subsection{Logging via syslogd}
# 
# No provisions for remote logging are made here as they are with rsyslog.

class log::syslog {
# \implements{macosxstig}{GEN005400 M6,GEN005420 M6}%
# Control ownership and permissions of the \verb!syslog.conf! file.
    file { '/etc/syslog.conf':
        owner => root, group => 0,
    }
# \implements{macosxstig}{GEN005395 M6}%
# Remove extended ACLs from the \verb!syslog.conf! file.
    no_ext_acl { '/etc/syslog.conf': }
}

