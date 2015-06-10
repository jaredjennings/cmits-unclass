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
# \section{Python}
#
# Install Python and whatever is necessary to use eggs.

class python {
    case $osfamily {
        "RedHat": {
            case $operatingsystemrelease {
                /6\..*/: { include python::rhel6 }
                /5\..*/: { include python::rhel5 }
                default: { unimplemented() }
            }
        }
# Python not yet implemented under Darwin.        
        'Darwin': {}
        default: {
            unimplemented()
        }
    }
}
