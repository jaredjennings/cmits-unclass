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
# \subsection{Trac}
#
# Deploy Trac in such a way as to support multiple instances.
#
# The installation of Trac is documented in the SBU administrator's guide
# \cite{sbu-admin}. Here we just take care of the multi-project part.

class sbu::trac {
    file { "/var/www/wsgi-bin":
        ensure => directory,
        owner => root, group => 0, mode => 0755,
    }
    file { "/var/www/wsgi-bin/trac.wsgi":
        ensure => file,
        owner => root, group => 0, mode => 0755,
        source => "puppet:///modules/sbu/trac/trac.wsgi",
    }

# \implements{iacontrol}{ECML-1} Configure Trac instances on the SBU server to
# show a banner with a security label at the top of each page.
# 
# Install the requisite templates in a directory common to all Trac instances.

    $tracs = '/var/www/tracs'
    $trac_common = "${tracs}/_common"

    file {
        "$tracs":
            ensure => directory,
            owner => root, group => 0, mode => 0755;
        "$trac_common":
            ensure => directory,
            owner => root, group => 0, mode => 0755;
        "$trac_common/templates":
            ensure => directory,
            owner => root, group => 0, mode => 0755;
        "$trac_common/templates/site.html":
            owner => root, group => 0, mode => 0644,
            source => 'puppet:///modules/sbu/trac/site.html';
        "$trac_common/templates/classbar.html":
            owner => root, group => 0, mode => 0644,
            source => 'puppet:///modules/sbu/trac/classbar.html';
    }

# Configure all Trac instances to inherit templates from the sitewide directory
# set up above.
#
# Specifically, in each trac.ini, add an inherit section if there isn't one,
# and set the \verb!templates_dir! setting in that section to the common
# templates directory.

    augeas { 'trac_inherit_common_templates':
        context => '/files/var/www/tracs/*/conf/trac.ini',
        changes => [
            "setm . inherit '' ",
            "setm inherit templates_dir '$trac_common/templates'",
        ],
    }
}
