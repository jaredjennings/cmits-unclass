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
# \subsubsection{Disable rsh, rlogin, and rexec under Mac OS X}

class rsh::no::darwin {
# \implements{macosxstig}{GEN003820 M6}%
# \implements{mlionstig}{OSX8-00-00050}%
# Make sure the rsh daemon is not running.
    service { 'com.apple.rshd':
        enable => false,
        ensure => stopped,
    }
# \implements{macosxstig}{GEN003840 M6}%
# \implements{mlionstig}{OSX8-00-00035}%
# Make sure the rexec daemon is not running.
    service { 'com.apple.rexecd':
        enable => false,
        ensure => stopped,
    }
# \implements{macosxstig}{GEN003850 M6}%
# \implements{mlionstig}{OSX8-00-00040}%
# Make sure the telnet daemon is not running.
    service { 'com.apple.telnetd':
        enable => false,
        ensure => stopped,
    }
# \implements{macosxstig}{GEN003860 M6}%
# \implements{mlionstig}{OSX8-00-01115}%
# Make sure the finger daemon is not running.
    service { 'com.apple.fingerd':
        enable => false,
        ensure => stopped,
    }
}
