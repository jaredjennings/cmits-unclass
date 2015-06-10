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
# \subsubsection{Apache STIG compliance on production web servers}

class apache::stig::production {

    include apache::stig::common

# \implements{apachestig}{WG080 A22}%
# Remove compilers from production web servers.
#
# (We do not detect here whether a web server is ``production.'')

    package {
        [
            'gcc',
            'gcc-c++',
            'gcc-gfortran',
            'libtool',
            'systemtap',
# No one should be building modules on the web server.
            'httpd-devel',
        ]:
            ensure => absent,
    }

# \implements{apachestig}{WG385 A22}%
# Remove all web server documentation, sample code, example applications and
# tutorials from production web servers.
#
# As above, we do not detect a production web server here. Since this is the
# only Category I requirement in this STIG, we'll make sure that it works
# across \verb!httpd! versions, rather than being a piece of tidy policy.

    exec { "rm_httpd_docs":
        command => "/bin/rm -rfv /usr/share/doc/httpd-[0-9]*",
        onlyif  => "/bin/ls      /usr/share/doc/httpd-[0-9]*",
        logoutput => true,
    }
    file {
        '/usr/share/man/man8/apachectl.8.gz':
            ensure => absent;
        '/usr/share/man/man8/htcacheclean.8.gz':
            ensure => absent;
        '/usr/share/man/man8/httpd.8.gz':
            ensure => absent;
        '/usr/share/man/man8/rotatelogs.8.gz':
            ensure => absent;
        '/usr/share/man/man8/suexec.8.gz':
            ensure => absent;
    }
    exec { "rm_mod_nss_docs":
        command => "/bin/rm -rfv /usr/share/doc/mod_nss-[0-9]*",
        onlyif  => "/bin/ls      /usr/share/doc/mod_nss-[0-9]*",
        logoutput => true,
    }
    package {
        "httpd-manual": ensure => absent;
# The debuginfo package may contain the source, which is the ultimate
# documentation.
        "httpd-debuginfo": ensure => absent;
    }
}
