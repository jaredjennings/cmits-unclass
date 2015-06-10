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
define automount::mount::darwin_10_6($under, $from, $ensure, $options) {
    if $under == '' {
# \implements{unixsrg}{GEN002420,GEN005900} Ensure the \verb!nosuid! option
# is used when mounting an NFS filesystem.
#
# \implements{unixsrg}{GEN002430} Ensure the \verb!nodev! option is used when
# mounting an NFS filesystem.
        mac_automount { "/net/${name}":
            source => $from,
            ensure => $ensure,
            options => ['nodev', 'nosuid', $options],
            notify => Service['com.apple.autofsd'],
        }
    }
    else {
        if !defined(Automount::Mount[$under]) {
            automount::mount { $under: ensure => absent, from => 'nonce:/dontmatter' }
        }
# \implements{unixsrg}{GEN002420,GEN005900} Ensure the \verb!nosuid! option
# is used when mounting an NFS filesystem.
#
# \implements{unixsrg}{GEN002430} Ensure the \verb!nodev! option is used when
# mounting an NFS filesystem.
        mac_automount { "/net/${under}/${name}":
            source => $from,
            ensure => $ensure,
            options => ['nodev', 'nosuid', $options],
            notify => Service['com.apple.autofsd'],
        }
    }
}
