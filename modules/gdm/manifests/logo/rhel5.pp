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
# \subsubsection{Setting the GDM logo under RHEL5}

class gdm::logo::rhel5($source) {
    $hic = "/usr/share/icons/hicolor"
    file {
        "$hic/48x48/stock/image/puppet-logo.png":
            owner => root, group => 0, mode => 0644,
            source => "${source}/logo-48x48.png";
        "$hic/scalable/stock/image/puppet-logo.png":
            owner => root, group => 0, mode => 0644,
            source => "${source}/logo-scalable.png";
    }

    $logo = "${hic}/scalable/stock/image/puppet-logo.png"

    require augeas
    augeas { 'gdm_logo':
        context => '/files/etc/gdm/custom.conf',
        changes => [
            'set daemon/Greeter /usr/libexec/gdmlogin',
            'set greeter/DefaultWelcome false',
# Don't ``welcome'' the user: legalities.
            'set greeter/Welcome "%n"',
            "set greeter/Logo ${logo}",
            ],
    }
}
