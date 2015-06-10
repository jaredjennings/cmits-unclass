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
# \section{Automount}
# \label{automount}
#
# Mount NFS filesystems via the automounter, under \verb!/net!.
#
# \implements{unixsrg}{GEN008440}%
# ``Automated file system mounting tools must not be enabled unless needed,''
# because they ``may provide unprivileged users with the ability to access
# local media and network shares.'' This automount configuration does not
# enable access to local media, and constricts network share access to filers
# designated for the purpose of serving unprivileged users.

class automount {
# If we're automounting we're going to be using NFS. Make sure we're prepared
# for that.
    include nfs

    include "automount::${::osfamily}"
}
