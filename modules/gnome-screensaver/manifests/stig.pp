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
# \subsection{STIG-required screensaver configuration}
class gnome-screensaver::stig {
# All settings we are about to set should go in the mandatory GConf tree. And
# that is the default for this resource type.
    gconf {
# \bydefault{RHEL6}{unixsrg}{GEN000510} Make sure the screensaver will only
# show something publicly viewable, such as a blank screen. RHEL6 does not ship
# with any screensavers that could show anything not publicly viewable.
        "/apps/gnome-screensaver/mode":
            ensure => absent;
# \implements{unixsrg}{GEN000500}%
# Cause the screen to lock after 15 minutes of inactivity, requiring
# re-authen\-tic\-ation to unlock it.
        "/apps/gnome-screensaver/idle_activation_enabled":
            type => bool, value => true;
# \implements{rhel5stig}{GEN000500-3} Enable the lock setting of the screensaver.
        "/apps/gnome-screensaver/lock_enabled":
            type => bool, value => true;
# \implements{rhel5stig}{GEN000500-2} Set the screensaver idle delay to 15
# minutes.
        "/apps/gnome-screensaver/idle_delay":
            type => int, value => 15;
    }
}
