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
# \subsection{Prepare computer object}
#
# Make an object for the computer so that we can set MCX settings on it. See
# \url{http://projects.puppetlabs.com/issues/5079} for why we would not just
# use \verb!/Computers/localhost!.

class mcx::prepare {
# This exec resource is lifted from 
# \url{http://flybyproduct.carlcaum.com/2010/03/managing-mcx-with-puppet-on-snow.html}.
# But we use the \verb!-F! switch to \verb!grep! so that it will treat the FQDN
# as a literal string to search for, not a regular expression. This may never
# matter but it is more correct.
    exec { "System in Local Directory":
        path => ['/bin', '/usr/bin'],
        command => "dscl localhost -create \
                    /Local/Default/Computers/$::fqdn \
                    ENetAddress $::macaddress_en0 \
                    RealName $::fqdn \
                    RecordName $::fqdn",
        unless => "dscl localhost -list \
                    /Local/Default/Computers | \
                    grep -F $::fqdn",
    }
}
