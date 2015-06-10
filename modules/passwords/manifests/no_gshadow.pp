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
# \subsection{Remove passwords from gshadow}

class passwords::no_gshadow {
# \implements{rhel5stig}{GEN000000-LNX001476} Disable group passwords.
#
# Although \verb!gshadow(5)! says that a password only needs to start with a
# single exclamation point to be invalid, the check listed for this requirement
# only matches double exclamation points. So that the check will succeed, we
# set everything to double exclamation points.
    case $::osfamily {
        RedHat: {
            augeas { 'disable_gshadow_passwords':
                context => '/files/etc/gshadow',
                changes => [
                    'set */password "!!"',
                ],
	        incl => '/etc/gshadow',
		lens => 'Gshadow.lns',
            }
        }
        default: { unimplemented() }
    }
}
