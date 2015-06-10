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
# \subsection{Satellite authentication using PAM}
#
# This is in direct accordance with section 8.10 of the RHN Satellite
# Installation Guide \cite{rhn-satellite-installation}.
#
# To achieve Active Directory authentication, obtain and install a PAM
# module on the Satellite server. Centrify works at AFSEO; SSS (part
# of RHEL) may work for this purpose; other products are also
# available.

class rhn_satellite::pam {

# In order to ``create a PAM service file for RHN Satellite'' and ``edit the
# file with the following information: [...],'' include one of the ensuing
# classes. The \verb!sss! class does exactly what the Installation Guide says
# to.
#
# ``Instruct the satellite to use the PAM service file...'' \verb!rhn.conf! is
# a Java properties file.
    augeas { 'rhn_satellite_use_pam':
        require => Augeas['rhn_satellite_pam_d'],
        context => '/files/etc/rhn/rhn.conf',
        changes => 'set pam_auth_service rhn-satellite',
# ``Restart the service to pick up the changes.''
        notify => Exec['rhn_satellite_restart'],
    }
}
