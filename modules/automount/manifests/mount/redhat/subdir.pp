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
# This is used only by automount::mount::redhat.

define automount::mount::redhat::subdir($ensure='present') {
    include automount

# First, make sure we don't tread on existing configuration.
    if $name == 'net' {
        fail('You cannot use automount::subdir to create /net/net')
    }

# Now, make a subtable in the automount configuration.
    file { "/etc/auto.${name}":
        owner => root, group => 0, mode => 0644,
        ensure => $ensure,
    }
    if $ensure == 'present' {
        augeas { "automount_add_master_subdir_${name}":
            context => '/files/etc/auto.master',
            changes => [
                "set map[.='/net/${name}'] /net/${name}",
                "set map[.='/net/${name}']/name /etc/auto.${name}",
                "set map[.='/net/${name}']/options --ghost",
                ],
            require => [],
        }
    } else {
        unimplemented()
    }
}
