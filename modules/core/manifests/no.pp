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
# \subsection{Turn off core dumps}
#
# \implements{unixsrg}{GEN003500}%
# Turn off core dumps because we do not need them.

class core::no {
    case $::osfamily {
        'RedHat': {
# This is done by means of \verb!pam_limits.so!. Make sure it's in place.
            include pam::limits

# Now configure \verb!pam_limits.so!. (See \S\ref{class_pam::max_logins}
# for another example.)
            augeas {
                "limits_insert_core":
                    context => "/files/etc/security/limits.conf",
                    onlyif => "match *[.='*' and item='core']\
                                     size == 0",
                    changes => [
                        "insert domain after *[last()]",
                        "set domain[last()] '*'",
                        "set domain[last()]/type hard",
                        "set domain[last()]/item core",
                        "set domain[last()]/value 0",
                    ];
                "limits_set_core":
                    require => Augeas["limits_insert_core"],
                    context => "/files/etc/security/limits.conf",
                    changes => [
                        "set domain[.='*' and item='core']/type hard",
                        "set domain[.='*' and item='core']/value 10",
                    ];
            }
        }
        'Darwin': {}
        default: { unimplemented() }
    }
}
        

# \notapplicable{unixsrg}{GEN003501,GEN003502,GEN003503,GEN003504,GEN003505}%
# With no core dumps, there is no centralized directory where core dumps are
# stored, so such a directory need not be secured.
