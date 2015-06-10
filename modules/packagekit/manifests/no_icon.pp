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
# \subsection{Remove package update icon}
#
# Users can't usefully install package updates. Don't bother showing them the
# icon.
class packagekit::no_icon {

# This works for RHEL6.
    file { "/etc/xdg/autostart/gpk-update-icon.desktop":
        ensure => absent,
    }

# This works for RHEL5.
    file { "/etc/xdg/autostart/puplet.desktop":
        ensure => absent,
    }
}
