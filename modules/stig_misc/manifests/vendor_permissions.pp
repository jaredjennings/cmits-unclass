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
# \subsection{Force permissions specified by vendors}
#
# \implements{macosxstig}{GEN001660 M6,GEN001680 M6}%
# To make sure all ``system start-up files'' are properly owned and group-owned
# on the Mac, run the disk utility to ``reset the ownership to the original
# installation settings.''
#
# \implements{macosxstig}{GEN006565 M6,GEN006570 M6,GEN006571 M6}%
# ``Verify system software periodically,'' including the ACLs of files and
# their extended attributes.

class stig_misc::vendor_permissions {
    case $osfamily {
        'darwin': {
            exec { 'startup_file_permissions':
                command => "/usr/sbin/diskutil \
                            repairPermissions /",
                loglevel => warning,
            }
        }
        default: { unimplemented() }
    }
}
