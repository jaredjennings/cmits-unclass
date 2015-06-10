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
# \subsection{Automount configuration under Mavericks}

class automount::darwin_10_9 {
# To edit automount maps we need Augeas.
    require augeas

# Augeas 1.2.0 does not appear to understand how to edit
# \verb!/etc/auto_master! on a Mavericks Mac, even if it doesn't
# contain anything weird. Oh, well; what we need in it is quite fixed
# anyway.
    file { '/etc/auto_master':
        owner => root, group => 0, mode => 0644,
        content => "
/net auto_net
",
    }

# Make sure the auto.net file exists: otherwise any attempt at editing it will
# fail, causing errors.
    file { "/etc/auto_net":
        owner => root, group => 0, mode => 0644,
        ensure => present,
    }

    augeas { "automount_remove_autonet_script":
        require => File["/etc/auto_net"],
        context => "/files/etc/auto_net",
        changes => "rm script_content",
    }
}
