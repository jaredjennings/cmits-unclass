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
# \section{PackageKit}
#
# PackageKit helps normal users install packages. It's intended to enable
# security and bugfix updates on computers where there is no real
# administrator---like home desktops. In general, any environment where we are
# running Puppet is an environment with a real administrator, and where there
# are admins, users should not be making decisions about software updates.
#
# Some parts of PackageKit look useful: for example, its service pack
# functionality. Admins can use \verb!pkcon!, \verb!pkgenpack!, or
# \verb!gpk-application! to access these parts; meanwhile, users should not be
# bothered with anything relating to software packages.

class packagekit {
    include packagekit::no_icon
    include packagekit::admin_auth
    include packagekit::no_auto
    include packagekit::no_notify
}
