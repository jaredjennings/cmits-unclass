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
# \section{Red Hat Network Satellite}
#
# Red Hat Network (RHN) Satellite servers are manually set up, entirely
# according to Red Hat's fine documentation. (Seriously, it's well-written and
# complete.) Any exceptions will be noted and/or controlled here.

class rhn_satellite {

# The RHN Satellite services are not managed by the service subsystem; there is
# a separate rhn-satellite executable which takes parameters stop, start,
# restart, status, etc.
    exec { 'rhn_satellite_restart':
        refreshonly => true,
        command => '/usr/sbin/rhn-satellite restart',
    }
}
