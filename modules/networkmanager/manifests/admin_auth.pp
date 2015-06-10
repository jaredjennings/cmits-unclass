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
# \subsection{Restrict network changes to admins}
#
# \implements{unixsrg}{GEN003581} Don't let users configure network interfaces:
# require authentication of an administrator to do this.
#
# \emph{N.B.} This will cause trouble on any host which may change networks in
# the normal course of duty---like a laptop.

class networkmanager::admin_auth {
    case $osfamily {
        RedHat: {
            case $operatingsystemrelease {

# RHEL6 comes with NetworkManager, and it works and lets users do things to
# configure the network unless it's configured otherwise. Here we configure it
# to require admin authentication for any changes.
                /^6\..*/: {

# Get rid of the pre-\verb!policykit::rule! file.
                    file {
"/etc/polkit-1/localauthority/90-mandatory.d/\
50-mil.af.eglin.afseo.admin-network.pkla":
                        ensure => absent,
                    }

                    policykit::rule { 'admin-auth-network':
                        description =>
'only admins can change network settings',
                        identity => '*',
                        action =>
"org.freedesktop.NetworkManager.*;\
org.freedesktop.network-manager-settings.*",
                    }
                }

# While RHEL5 comes with NetworkManager, it appears that it doesn't come with
# PolicyKit, and it also doesn't appear that you can do anything with the
# network settings without being an admin, as required.
                /^5\..*/: {}

                default: { unimplemented() }
            }
        }
# % FIXME: Where does Darwin comply with GEN003581?
# Darwin doesn't have NetworkManager.
        Darwin: {}
        default: { unimplemented() }
    }
}
