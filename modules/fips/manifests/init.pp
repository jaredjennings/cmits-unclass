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
# \section{FIPS 140-2 compliance, general}
#
# For compliance with Federal Information Processing Standard (FIPS) 140-2,
# there are two main ingredients: accreditation and configuration. The
# cryptographic modules used must be accredited, and they must be used in a
# compliant manner.
#
# (In some places in this document we say ``FIPS compliance.'' While we are
# likely to comply with other FIPS standards, 140-2 is the only one that
# anyone's asked about so far, so, for the time being, this is what ``FIPS
# compliance'' means.)

class fips {
    case $::osfamily {
        'RedHat': {
            case $::operatingsystemrelease {
                /^6\..*/: {
                    require fips::rhel6
                }
                /^5\..*/: {
                    require fips::rhel5
                }
                default: { unimplemented() }
            }
        }
        'Darwin': {
            require fips::darwin
        }
    }
}
