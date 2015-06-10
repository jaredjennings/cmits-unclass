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
class cups::redhat {
# Since \verb!cups::no! uninstalls CUPS, and this class already assumes CUPS is
# installed, we may as well make sure of it, so that if some node switches from
# including \verb!cups::no! to including \verb!cups::stig!, things will work
# better. But CUPS is not necessarily all that must be installed for printing
# to work properly in a given situation.
    package { 'cups':
        ensure => present,
    }
    service { 'cups':
        enable => true,
        ensure => running,
        require => Package['cups'],
    }
}
