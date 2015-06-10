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
# \section{LDAP}
#
# We do not presently use the Lightweight Directory Access Protocol (LDAP) for
# authentication, but if we did, we would have to implement these requirements:
#
# \notapplicable{unixsrg}{GEN007970,GEN007980,GEN008000}%
# \notapplicable{unixsrg}{GEN008020,GEN008040,GEN008050}%
# Systems using LDAP for authentication or account information must use
# FIPS-approved means for constructing a TLS connection, use DoD-signed
# certificates to authenticate themselves and the server, and check for trust
# and revocation of the server certificate. Use this PKI-based method or
# Kerberos, not storage of a password, to authenticate LDAP client hosts.
#
# \notapplicable{macosxstig}{OSX00115 M6,OSX00120 M6,OSX00125 M6}%
# \notapplicable{macosxstig}{OSX00121 M6,OSX00122 M6,OSX00123 M6,OSX00124 M6}%
# Macs using LDAP must be ``securely configured'' in a variety of ways.
