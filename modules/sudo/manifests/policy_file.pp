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
define sudo::policy_file($content='', $ensure='present', $sudoers='', $sudoers_d='') {
    require sudo
    include sudo::params

    $d_sudoers = $sudoers ? {
        ''      => $sudo::params::sudoers,
        default => $sudoers,
    }
    $d_sudoers_d = $sudoers_d ? {
        ''      => $sudo::params::sudoers_d,
        default => $sudoers_d,
    }

    sudo::include_policy_file { $name:
        ensure => $ensure,
        sudoers => $d_sudoers,
        sudoers_d => $d_sudoers_d,
    }

    file { "${d_sudoers_d}/${name}":
        ensure => $ensure,
        owner => root, group => 0, mode => 0440,
        content => $content,
    }

# When placing a new file, we should make sure the file is in place
# before telling sudo to include it. When removing a file, we must
# make sure sudo isn't including it before we remove the file. This is
# because Snow Leopard's \verb!sudo! segfaults if anything is wrong
# with its configuration as a whole, with the ... undesirable result
# that no one can sudo to do anything.

    case $ensure {
        'present': {
            File["${d_sudoers_d}/${name}"] ->
            Sudo::Include_policy_file[$name]
        }
        default: {
            Sudo::Include_policy_file["$name"] ->
            File["${d_sudoers_d}/${name}"]
        }
    }
}
