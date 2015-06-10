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
# \subsection{RHEL 5 FIPS 140-2 guidance}
#
# This is just like RHEL 6 but simpler: the knowledge base article
# \url{https://access.redhat.com/kb/docs/DOC-39230} applies directly.
#
# See
# \url{http://www.redhat.com/solutions/industry/government/certifications.html}
# for FIPS approval status of crypto modules in RHEL.

class fips::rhel5 {
# Make sure we have fipscheck: FIPS-compliant OpenSSL uses it to check itself
# during startup.
    package {
        "fipscheck": ensure => present;
        "fipscheck-lib": ensure => present;
    }

    include prelink::no
    include grub::fips
    include ssh::fips

}
