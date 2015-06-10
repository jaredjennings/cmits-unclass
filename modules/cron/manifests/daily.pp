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
# \subsection{Daily cron job}
#
# Make sure something happens every day---portably.
#
# On Red Hattish Linux hosts, \verb!/etc/cron.daily! exists and is a
# directory, and executable files inside it are run once a day. On Mac
# hosts, this directory does not exist.

define cron::daily($source) {
    case $::osfamily {
        'RedHat': {
            file { "/etc/cron.daily/${name}":
                owner => root, group => 0, mode => 0700,
                source => $source,
            }
        }
        'Darwin': {
            warning 'cron::daily unimplemented on Macs'
        }
    }
}
