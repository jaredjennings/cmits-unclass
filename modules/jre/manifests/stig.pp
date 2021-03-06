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
# \subsection{STIG-required JRE configuration}
#
# The Java Runtime Environment (JRE) STIG \cite[jre-stig] has some DoD-level
# requirements regarding how the JRE must deal with cryptographically signed
# code. Here we enforce those requirements.

define jre::stig(
        $jre='/usr/lib/jvm/jre-1.6.0') {
    
# \implements{jrestig}{JRE0080-UX} Make sure the deployment properties file
# exists.

    $dp = "${jre}/lib/deployment.properties"

    file { $dp:
        ensure => present,
        owner => root, group => 0, mode => 0644,
    }


# Enforce policy regarding the contents of the deployment properties file.

    $notinca = "deployment.security.askgrantdialog.notinca"
    $crl     = "deployment.security.validation.crl"
    $ocsp    = "deployment.security.validation.ocsp"

    augeas { "jre_stig_${jre}_deployment_properties":
        lens => 'Properties.lns',
        incl => $dp,
        changes => [

# \implements{jrestig}{JRE0001-UX} ``Disable ability to grant permission to
# untrusted authority.''
            "set ${notinca} false",

# \implements{jrestig}{JRE0010-UX} ``Lock out option to grant permission to
# untrusted.''
            "set ${notinca}.locked true",

# \implements{jrestig}{JRE0020-UX} ``Enable revocation check on publisher
# certificates.''
            "set ${crl} true",

# \implements{jrestig}{JRE0030-UX} ``Lock the option to check certificates for
# revocation.''
            "set ${crl}.locked true",

# \implements{jrestig}{JRE0040-UX} ``Enable online certificate validation.''
            "set ${ocsp} true",

# \implements{jrestig}{JRE0050-UX} ``Lock online certificate validation.''
            "set ${ocsp}.locked true",
        ],
    }

# \implements{jrestig}{JRE0070-UX} Make sure the deployment configuration file
# exists.

    $dc = "${jre}/lib/deployment.config"

    file { $dc:
        ensure => present,
        owner => root, group => 0, mode => 0644,
    }

# Enforce policy regarding the contents of the deployment configuration file.

# \implements{jrestig}{JRE0060-UX} Configure the deployment configuration file
# to point at the deployment properties file.

    $dsconfig = "deployment.system.config"

    augeas { "jre_stig_${jre}_deployment_config":
        lens => 'Properties.lns',
        incl => $dc,
        changes => "set ${dsconfig} \"file:${dp}\"",
    }
}

