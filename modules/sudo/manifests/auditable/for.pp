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
define sudo::auditable::for(
    $run_as='ALL',
    $no_password=true,
) {
    $user_spec = $name
    $modifiers = $no_password ? {
        true    => 'NOPASSWD:',
        default => '',
    }
    $safe_userspec =     regsubst($user_spec, '[^a-zA-Z_]', '_')
    require sudo::auditable::whole
    sudo::policy_file { "99${safe_userspec}":
        ensure => present,
        content => template("${module_name}/auditable/rule.erb"),
    }
    sudo::remove_direct_sudoers_policy { "${name}": }
}
