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
# \subsection{Automount configuration under Red Hat}

class automount::redhat {
# To edit automount maps we need Augeas.
    require augeas

    package { "autofs": ensure => present}

    augeas { "automount_fixed_net_map":
        context => "/files/etc/auto.master",
        changes => [
            "set map[.='/net'] /net",
            "set map[.='/net']/name /etc/auto.net",
            "set map[.='/net']/options --ghost",
            "rm include",
            "rm map[.='/misc']",
        ],
    }

# Make sure the auto.net file exists: otherwise any attempt at editing it will
# fail, causing errors.
    file { "/etc/auto.net":
        owner => root, group => 0, mode => 0644,
        ensure => present,
    }

    augeas { "automount_remove_autonet_script":
        require => File["/etc/auto.net"],
        context => "/files/etc/auto.net",
        changes => "rm script_content",
    }

    service { "autofs":
        enable => true,
        ensure => running,
        require => Package["autofs"],
# For some reason some NFS mounts added did not show up when \verb!autofs! was
# restarted using the \verb!reload! verb instead of \verb!restart!. So even
# though \verb!restart! is slower and could screw more things up, it's what we
# need to use.
        restart => "/sbin/service autofs restart",
    }
}
