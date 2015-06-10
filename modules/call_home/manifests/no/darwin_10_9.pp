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
class call_home::no::darwin_10_9 {
# \implements{mlionstig}{OSX8-00-00531}%
# Disable ``Find My Mac.''
    service { 'com.apple.findmymacd':
        ensure => stopped,
        enable => false,
    }

# \implements{mlionstig}{OSX8-00-00532}%
# Disable the ``Find My Mac'' messenger.
    service { 'com.apple.findmymacmessenger':
        ensure => stopped,
        enable => false,
    }

# \implements{mlionstig}{OSX8-00-00530}%
# Disable the sending of diagnostic and usage data to Apple.
    $lascr = '/Library/Application Support/CrashReporter'
    mac_plist_value { 'turn off AutoSubmit':
        file => "${lascr}/DiagnosticMessagesHistory.plist",
        key => 'AutoSubmit',
        value => false,
    }
}
