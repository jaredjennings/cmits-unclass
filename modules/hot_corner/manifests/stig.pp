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
# \subsection{Prevent users from disabling screensaver}

class hot_corner::stig {

# \implements{macosxstig}{OSX00375 M6}%
# \implements{mlionstig}{OSX8-00-01095}%
# Prevent users from configuring a hot corner to disable the
# screensaver.
#
# Another way to do this besides disabling all hot corners would be to
# force the hot corner configuration to something known to be
# compliant.
    hot_corner {
        'tl': action => 'nothing';
        'tr': action => 'nothing';
        'bl': action => 'nothing';
        'br': action => 'nothing';
    }
}

