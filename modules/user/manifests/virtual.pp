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
class user::virtual {
    User {
        shell => '/bin/bash',
        ensure => 'present',
        password => '!!',
    }

    @user {
        logview:
            comment => "Log viewing user",
            gid => logview, uid => 49152;
        'puppet_dba':
            comment => "OS user used by Puppet to administer PostgreSQL",
            gid => puppet_dba, uid => 49153;
    }

    @group {
        logview:
            gid => 49152;
        puppet_dba:
            gid => 49153;
    }
}
