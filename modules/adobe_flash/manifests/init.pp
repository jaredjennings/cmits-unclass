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
# \section{Adobe Flash Player}
#
# Some users may require the Adobe Flash Player. Getting this to work for them
# is a challenge because Linux is not well supported by Adobe these days: For
# 64-bit support, as of March 2013, there have been two attempts at an x86\_64
# Flash plugin from Adobe, and neither was supported by security
# updates.\footnote{There have been 81 vulnerabilities in Flash in the last
# year, 76 of which were critical (source:
# \url{http://www.cvedetails.com/vulnerability-list/vendor_id-53/product_id-6761/Adobe-Flash-Player.html}),
# so security updates are a must.} And Adobe is phasing out even 32-bit Linux
# support.
#
# The \verb!flash-plugin! package is in the Supplementary RHN channel, so any
# host that needs Flash must be subscribed to that channel, or the package will
# not be visible on the host.

class adobe_flash {

    case $::osfamily {
        'RedHat': {
# Being from Red Hat, the \verb!flash-plugin! package takes care of its own
# wrapping, if all the packages it needs are installed. So we needn't actually
# wrap the plugin ourselves, just get the prerequisites in place.
            include mozilla::wrap_32bit::prerequisites

# The 64-bit Flash plugin can get in the way, because these days yum
# detects when a package is installed twice, once each for the i686
# and x86\_64 architectures, and refuses to upgrade only one
# architecture-specific package of the pair and leave the other out of
# date; but Red Hat has stopped releasing new 64-bit flash-plugin
# packages.
            package { 'flash-plugin.x86_64':
                ensure => absent,
            }

            package { 'flash-plugin.i686':
                ensure => present,
                require => Class[Mozilla::Wrap_32bit::Prerequisites],
            }
        }
        'Darwin': {
            warning 'adobe_flash unimplemented on Macs'
        }
    }
}
