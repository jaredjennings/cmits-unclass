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
# \subsubsection{Collect remote audit messages}
#
# The audit message collector host must include this class.

class audit::remote::collect($realm) {

# These steps come from
# \url{http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/5/html/Deployment_Guide/s1-kerberos-server.html}.
# That document regards RHEL5; it appears that RHEL6 documentation does not
# contain things about Kerberos servers.
#
# Install needed packages on the KDC (Key Distribution Center) host.

    package { [
            'krb5-libs',
            'krb5-server',
            'krb5-workstation',
        ]:
            ensure => present,
    }

# Configure the KDC service.

    include augeas
    $ourrealm = "realms/realm[.='$realm']"
    augeas { "audit_kdc_set_realm":
        require => Class['augeas'],
        context => '/files/var/kerberos/krb5kdc/kdc.conf',
        changes => [
            "rm realms/realm[.='EXAMPLE.COM']",
            "rm realms/realm[.='$realm']",
            "set realms/realm[999] $realm",
            "set $ourrealm/acl_file \
                 /var/kerberos/krb5kdc/kadm5.acl",
            "set $ourrealm/admin_keytab \
                 /var/kerberos/krb5kdc/kadm5.keytab",
            "set $ourrealm/supported_enctypes/type \
                 aes256-cts:normal",
        ],
    }

# Configure the \verb!krb5.conf!.
#
# This is done as an exported resource, so that the hosts which generate audit
# records can configure themselves with the resource as well. Values for
# variables used inside this resource are figured on the audit collector host,
# not on the generator hosts.
# 
# The krb5.conf lens is part of Augeas, so we need not depend on our Augeas
# customizations for this resource.

    @@augeas { "audit_krb5_conf":
        context => '/files/etc/krb5.conf',
        changes => [
            "rm realms/realm[.='$realm']",
            "set realms/realm[999] $realm",
            # $ourrealm is set above the previous augeas resource
            "set $ourrealm/kdc $::fqdn",
            "set $ourrealm/admin_server $::fqdn",

            "set libdefaults/default_realm $realm",
            "set domain_realm/$::domain $realm",
            "set domain_realm/.$::domain $realm",
        ],
        tag => "audit_krb5_for_${::fqdn}",
    }

# The Augeas resource that configures the krb5.conf, both for audit producing
# hosts and audit collecting hosts, is written
# in~\S\ref{class_audit::remote::collect}.
#
# Collect that exported resource on the audit collector host.

    Augeas <<| tag == "audit_krb5_for_${::fqdn}" |>>

# Configure admin access to the KDC.

    file { "/var/kerberos/krb5kdc/kadm5.acl":
        owner => root, group => 0, mode => 0600,
        content => "*/admin@$realm\t*\n",
    }

# Create the database.
#
# First, we'll need some passwords. 

    define choose_password($write_to_file) {
        exec { $name:
# We're basing it on a random number, so we want FIPS compliance in place
# first.
            require => Class['fips'],
            command => "/usr/bin/head -c 50 /dev/random | \
                 /usr/bin/sha1sum | \
                 /bin/cut -d' ' -f1 > ${write_to_file}",
            creates => $write_to_file,
# Disable timeout: there's no way to know how long it will take to come up with
# enough entropy.
            timeout => 0,
        }
    }

# Choose a password for the master principal.

    $masterpass = '/var/kerberos/krb5kdc/.masterpass'
    choose_password { 'master':
        write_to_file => $masterpass,
    }

# Armed with the master password, create the database.
    exec { 'audit_create_krb5_db':
        require => [
            Augeas['audit_kdc_set_realm'],
            File['/var/kerberos/krb5kdc/kadm5.acl'],
        ],
        command => "/bin/cat ${masterpass} ${masterpass} | \
                         /usr/sbin/kdb5_util create -s",
        creates => '/var/kerberos/krb5kdc/principal',
    }

# Now we need a principal for Puppet to use to do all of the admin work
# specified in this manifest.
#
# Choose a password for that principal.

    $puppetpass = '/var/kerberos/krb5kdc/.puppetpass'
    choose_password { 'puppet':
        write_to_file => $puppetpass,
    }

# Add the principal. Since adding the principal doesn't make anything happen
# that we can see from Puppet, we have to make a stamp file to avoid doing it
# twice.

    $puppetstamp = '/var/kerberos/krb5kdc/.stamp-puppet'

    exec { 'audit_create_puppet_princ':
        require => [
            Choose_password['puppet'],
            Exec['audit_create_krb5_db'],
        ],
        command => "/bin/cat ${puppetpass} ${puppetpass} | \
                    /usr/sbin/kadmin.local \
                        -q 'addprinc puppet' \
                    > ${puppetcookie}",
        creates => $puppetcookie,
    }

# Now set the KDC and kadmin running.

    service { 'krb5kdc':
        require => [
            Package['krb5-server'],
            Augeas['audit_krb5_conf'],
            Exec['audit_create_krb5_db'],
            Exec['audit_create_puppet_princ'],
        ],
        ensure => running,
        enable => true,
    }

    service { 'kadmin':
        require => [
            Package['krb5-server'],
            Augeas['audit_krb5_conf'],
            Exec['audit_create_krb5_db'],
            Exec['audit_create_puppet_princ'],
        ],
        ensure => running,
        enable => true,
    }
}
