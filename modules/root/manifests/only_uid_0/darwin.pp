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
class root::only_uid_0::darwin {
# \implements{macosxstig}{GEN000880 M6}%
# \implements{mlionstig}{OSX8-00-01065}%
# Ensure that only root has user id 0.
#
# If the final grep exits without error, it found something. Then we
# run the command and log its output as errors. Because of the onlyif,
# we get no log messages if everything is OK.
    exec { 'warn if other users have uid 0':
        onlyif => 'dscl . -list /Users UniqueID | \
                    grep -w 0 | \
                    grep -v -w ^root',
        command => 'dscl . -list /Users UniqueID | \
                    grep -w 0 | \
                    grep -v -w ^root',
        loglevel => err,
    }
}
