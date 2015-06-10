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
# Configure the Mac screensaver as required by the Mac OS X STIG.

class screensaver::stig {
    include screensaver::public_pattern
    include screensaver::no_admin_unlock
# \implements{macosxstig}{OSX00360 M6}%
# \implements{mlionstig}{OSX8-00-00010}%
# Set the screensaver idle timeout to ``15 minutes or less.''
    class { 'screensaver::timeout':
        seconds => 900,
    }
# Implied by the rule title of \macosxstig{OSX00360 M6} but not covered by the
# check and fix content is that the screensaver must require authentication to
# unlock.
    include screensaver::authenticate
}
