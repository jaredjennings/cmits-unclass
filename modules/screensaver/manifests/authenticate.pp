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
# \subsection{Require authentication to exit screensaver}

class screensaver::authenticate {

# \implements{macosxstig}{OSX00360 M6,OSX00420 M6}%
# \implements{mlionstig}{OSX8-00-00020}%
# Password-protect Mac screensavers.
#
# This requirement is in the rule title of \macosxstig{OSX00360 M6}, but not in
# the check or fix content. \macosxstig{OSX00420 M6} directly requires it.
    mcx::set {
        'com.apple.screensaver/askForPassword':
            value => 1;
        'com.apple.screensaver/askForPasswordDelay':
            value => 0;
    }
}
