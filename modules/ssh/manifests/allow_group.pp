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
# \subsection{Limit SSH login by group membership}
#
# \implements{unixsrg}{GEN005521} Restrict login via SSH to members of certain
# groups.
#
# (If any groups are listed in the \verb!AllowGroups! directive of the
# \verb!sshd! configuration, all other groups are denied login.)
#
# Note that while this define can add a group to the AllowGroups directive, it
# cannot take one away. Taking some away would require knowing the entire set
# of them, but each \verb!ssh::allow_group! only knows about itself. Perhaps
# some cunning artificer could use virtual resources to make this work right,
# but I'm not that person right now.

define ssh::allow_group() {
    include ssh
    include ssh::allow_group::ins
    augeas {
        "sshd_allow_group_${name}":
            require => Augeas["sshd_ins_allow_group"],
            context => "/files${ssh::server_config}",
            changes => [
                "set AllowGroups/10000 '${name}'",
            ],
            onlyif => "match AllowGroups/*[.='${name}'] \
                       size == 0";
    }
}
