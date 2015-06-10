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
# \subsection{Require admin authentication}
#
# Keep normal users from installing or removing software.

class packagekit::admin_auth {
    case $osfamily {
        RedHat: {
            case $operatingsystemrelease {

                /^6\..*/: {

# Get rid of the pre-\verb!policykit::rule! file.
                        file {
"/etc/polkit-1/localauthority/90-mandatory.d/\
50-mil.af.eglin.afseo.admin-packagekit.pkla":
                            ensure => absent,
                        }

                        policykit::rule { 'admin-packagekit':
                            description =>
'require admin authn for package actions',
                            identity => '*',
                            action =>
'org.freedesktop.packagekit.*',
                        }
                }

# RHEL5 includes neither PackageKit nor PolicyKit, so users already can't
# install or remove software without admin privileges.
                /^5\..*/: {}

                default: { unimplemented() }
            }
        }
    }
}
