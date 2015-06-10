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
# \subsection{Disable SNMP}
#
# \notapplicable{unixsrg}{GEN005300}%
# We don't use SNMP on UNIX hosts (yet?). It's not merely inactive, it's not
# installed, so there are no default communities, users or passphrases.
#
# \notapplicable{unixsrg}{GEN005305}%
# If and when SNMP is ever deployed, do not use versions 1 or 2, but only
# version 3 or later.
#
# \notapplicable{unixsrg}{GEN005306,GEN005307}%
# Use FIPS 140-2 approved algorithms for SNMP.
#
# \notapplicable{unixsrg}{GEN005320,GEN005340,GEN005350,GEN005360,GEN005365,GEN005375}%
# Being as we don't run SNMP, none of its configuration files exist.

class snmp::no {
# \verb!tog-pegasus! depends on \verb!net-snmp!, so it must be removed also.
    package { [
            'net-snmp',
            'tog-pegasus',
        ]:
        ensure => absent,
    }
}
