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
# \subsection{Limit maximum logins}
#
# \implements{iacontrol}{ECLO-1} Configure the system to limit the maximum
# number of logins.
#
# Note that each terminal window opened by a user may consume a login, so if
# you have more than \verb!$limit! terminal windows open, and then you go to
# another host, and try to \verb!ssh! to your workstation, you could be denied.

class pam::max_logins($limit=10) {

# This is done by means of \verb!pam_limits.so!. Make sure it's in place.
    include pam::limits

# Now---\verb!pam_limits.so! gets its list of limits from a configuration file.
# Make sure that file says that everyone has a maxlogins of 10.
    augeas {
        "limits_insert_maxlogins":
            context => "/files/etc/security/limits.conf",
            onlyif => "match *[.='*' and item='maxlogins']\
                             size == 0",
            changes => [
                "insert domain after *[last()]",
                "set domain[last()] '*'",
                "set domain[last()]/type hard",
                "set domain[last()]/item maxlogins",
                "set domain[last()]/value ${limit}",
            ];
        "limits_set_maxlogins":
            require => Augeas["limits_insert_maxlogins"],
            context => "/files/etc/security/limits.conf",
            changes => [
                "set domain[.='*' and item='maxlogins']/type hard",
                "set domain[.='*' and item='maxlogins']/value ${limit}",
            ];
    }
}
