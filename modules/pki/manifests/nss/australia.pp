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
# \subsection{Let Australian DoD certs in}
#
# This defined resource type will install DoD CCEB interoperability root CA
# certificates into the named database. These offer a trust path to
# some certificates issued outside the DoD. See
# \url{http://iase.disa.mil/pki-pke/interoperability/} for more details, and
# for rules under which you must operate when trusting this CA from a DoD
# server.
#
# It also will install Australian Defence Organisation (sp?) certs.

define pki::nss::australia($pwfile='', $sqlite=true) {
    Nss_cert {
        source => "puppet:///modules/pki/all-ca-certs/",
        pwfile => $pwfile,
        sqlite => $sqlite,
        require => Pki::Nss::Db[$name],
    }
    nss_cert { "${name}:DoD-CCEB-Interop-Root-CA1":
        trustargs => 'CT,C,C',
    }
    nss_cert {
        "${name}:Bridge-DoDCCEBIRCA1-ADOCA03": ;
        "${name}:ADO-CA014": ;
        "${name}:ADO-CA016": ;
    }
}
