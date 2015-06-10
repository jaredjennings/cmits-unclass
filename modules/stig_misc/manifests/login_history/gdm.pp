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
# \subsubsection{At the GDM login}

class stig_misc::login_history::gdm {
    if($gdm_installed == 'true') {
        include zenity
        package { "loginhistory": ensure => present, }
        file { "/etc/gdm/PostLogin/Default":
            require => Package["zenity"],
            owner => root, group => 0, mode => 0755,
            ensure => present,
            source => "puppet:///modules/stig_misc/\
login_history/gdm-post-login.sh",
        }
    }
}
