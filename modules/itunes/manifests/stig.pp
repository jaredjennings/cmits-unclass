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
# \subsection{STIG-required configuration}
#
# Configure iTunes in accordance with the Mac OS X STIG.

class itunes::stig {

# \implements{macosxstig}{OSX00530 M6}%
# \implements{mlionstig}{OSX8-00-01140,OSX8-00-01150,OSX8-00-01155}%
# Disable iTunes Store and other network features of iTunes on Macs.
#
# Note that because this policy uses an MCX object, it imposes this setting on
# every user at once, obviating any actions that must be ``performed for each
# user.''
    mcx::set { [
            'com.apple.iTunes/disableMusicStore',
            'com.apple.iTunes/disablePing',
            'com.apple.iTunes/disablePodcasts',
            'com.apple.iTunes/disableRadio',
            'com.apple.iTunes/disableSharedMusic',
            ]:
        value => true,
    }
}
