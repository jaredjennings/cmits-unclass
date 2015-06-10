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
# \subsection{Turn off notifications}
#
# For users who somehow have the \verb!gpk-update-icon! running, turn off
# notifications to them about things which, after all, they can't control.

class packagekit::no_notify {
    Gconf {
        type => bool, value => false,
    }
    $agpui = "/apps/gnome-packagekit/update-icon"
    gconf {
        "$agpui/notify_update_failed":;
        "$agpui/notify_critical":;
        "$agpui/notify_available":;
        "$agpui/notify_distro_upgrades":;
        "$agpui/notify_complete":;
        "$agpui/notify_update_started":;
        "$agpui/notify_update_complete_restart":;
        "$agpui/notify_update_complete":;
        "$agpui/notify_message":;
        "$agpui/notify_errors":;
        "$agpui/notify_update_not_battery":;
    }
}
