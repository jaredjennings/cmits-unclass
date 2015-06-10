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
# \subsection{World-writable directories}

class stig_misc::world_writable {

# FIXME: You can tell Vagrant to use a different directory than
# \verb!/tmp/vagrant-puppet!; this is just a default; but the code
# below hardcodes it.
    $exceptions = $::vagrant_puppet_provisioning ? {
        'true' => '\! -path /tmp/vagrant-puppet',
        default => '',
    }

# \implements{macosxstig}{GEN002500 M6}%
# \implements{mlionstig}{OSX8-01120}%
# Find and warn administrators about world-writable directories without the
# sticky bit set.
#
# We use \verb!xdev! so as not to traverse onto NFS filesystems---indeed, not
# onto any filesystem other than the root filesystem. On Linux hosts this find
# may not be large enough in scope, but on Macs it should be.
    exec { 'find_non_sticky_world_writable':
        path => ['/bin', '/usr/bin'],
        command => "find / -xdev \
                    -type d -perm -2 \\! -perm -1000 \
                    ${exceptions} \
                    -ls",
        onlyif => "find / -xdev \
                    -type d -perm -2 \\! -perm -1000 \
                    ${exceptions} \
                    -ls  |  grep . >&/dev/null",
        logoutput => true,
        loglevel => err,
    }

# \implements{macosxstig}{GEN002520 M6}%
# \implements{mlionstig}{OSX8-00-01110}%
# Find and warn administrators about public directories not owned by root.
    exec { 'find_public_non_root_owned':
        path => ['/bin', '/usr/bin'],
        command => "find / -xdev \
                    -type d -perm -1002 \\! -user root \
                    -ls",
        onlyif => "find / -xdev \
                    -type d -perm -1002 \\! -user root \
                    -ls  |  grep . >&/dev/null",
        logoutput => true,
        loglevel => err,
    }
}
