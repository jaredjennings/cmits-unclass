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
# \section{Mac packages}
#
# The \verb!apple! and \verb!pkgdmg! providers for the \verb!package!
# resource type require that a \verb!source! parameter be given. Mac
# packages will be stored on some NFS or HTTP location, but that
# location is specific to a given network, and \verb!modules-unclass!
# is supposed to be generic.
#
# This define exists to gather all of the references to such a location
# into one place.

define mac_package(
    $ensure='installed',
    $sourcedir='',
    ) {

# We haven't got Hiera installed on our Puppet 2 master server.
    if $sourcedir == '' {
        if $::puppet_version !~ /^3\./ {
            $use_source = '/'
        } else {
            $use_source = hiera('mac_package::sourcedir', '/')
        }
    } else {
        $use_source = $sourcedir
    }

# Attempt to autorequire the network mount that the sourcedir appears
# to be on.
    if $use_source =~ /^(\/net\/[^\/]+)/ {
        if defined(Mac_automount[$1]) {
            $requires = [Mac_automount[$1]]
        } else {
            $requires = []
        }
    } else {
        $requires = []
    }

    package { $name:
        ensure => $ensure,
        source => "${use_source}/${name}",
        require => $requires,
    }
}
