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
class hpcmp::kerberos::redhat {
    package { 'hpc_krb5':
        ensure => present,
    }

# If we're using some other form of Kerberos, the \verb!/etc/krb5.conf! file
# may be automatically, repeatedly overwritten with settings not useful to us
# in getting HPCMP Kerberos tickets. So we want to explicitly use an
# HPCMP-specific configuration when doing HPCMP Kerberos.
    file { '/etc/profile.d/hpc_krb5.sh':
        owner => bin, group => 0, mode => 0444,
        content => "\
hpc_krb5=/usr/local/hpc_krb5
export PATH=\$hpc_krb5/bin:\$PATH
alias pkinit=\"KRB5_CONFIG=\$hpc_krb5/etc/krb5.conf \\\n\
                pkinit \"\n\
",
    }
# We need DoD root and CA certificates. These are off in the pki module so that
# we can have only one copy of the certificates.
    include pki::ca_certs::pkinit
}
