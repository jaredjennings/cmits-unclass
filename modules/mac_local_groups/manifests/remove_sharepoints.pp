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
# \subsection{Remove sharepoint groups}
#
# There are some ``sharepoint'' groups on any given Mac, which have
# something to do with sharing folders over the network (not with
# Microsoft Sharepoint). We don't share folders from our Macs, only
# from our filers, so we don't need membership in these groups. But we
# do have many other groups. NFSv3 has a sixteen-group limit, and some
# of our users have nearly sixteen groups that it's important they be
# in. The sharepoint groups count against that maximum, and they
# contain the \verb!everyone! group nested inside them, so here we
# remove that so to free up groups for our users.

class mac_local_groups::remove_sharepoints {
    define remove_everyone_from() {
        $everyone_uuid = "ABCDEFAB-CDEF-ABCD-EFAB-CDEF0000000C"
        exec { "remove everyone from ${name}":
            onlyif => "/usr/bin/dscl . \
                           -read /Groups/${name} NestedGroups | \
                       /usr/bin/grep ${everyone_uuid} >&/dev/null",
            command => "/usr/bin/dscl . \
                           -delete /Groups/${name} NestedGroups \
                                   ${everyone_uuid}",
        }
    }
    remove_everyone_from { 'com.apple.sharepoint.group.2': }
    remove_everyone_from { 'com.apple.sharepoint.group.3': }
}
