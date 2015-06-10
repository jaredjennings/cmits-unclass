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
class sudo::auditable::whole(
    $sudoers=$sudo::params::sudoers,
    $sudoers_d=$sudo::params::sudoers_d,
    ) inherits sudo::params {
# It may be possible to use augeas instead of datacat, but as of May
# 2014 the Augeas sudoers lens couldn't seem to deal with aliases
# having items starting with bangs (\verb+!+), which would prevent us
# from disallowing anything. Whitelisting each possible binary by name
# would be a sad business.
    datacat { "sudoers.d/90auditable_whole":
        path => "${sudoers_d}/90auditable_whole",
        template => "${module_name}/auditable/whole.erb",
        owner => root, group => 0, mode => 0440,
    } ->
    sudo::include_policy_file { "90auditable_whole":
        sudoers => $sudoers,
        sudoers_d => $sudoers_d,
    }
}
