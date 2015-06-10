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
class core::stig::darwin {
    $core_dir = '/Library/Logs/DiagnosticReports'
    file { $core_dir:
# \implements{mlionstig}{OSX8-00-01175}%
# Ensure root owns the centralized core dump data directory.
# \implements{mlionstig}{OSX0-00-01185}%
# Ensure the group admin owns the centralized core dump data
# directory.
        owner => root, group => admin,
# \implements{mlionstig}{OSX8-00-01180}%
# Ensure restrictive permissions on the centralized core dump data
# directory.
        mode => 0750,
    }
}
