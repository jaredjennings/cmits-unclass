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
# \paragraph{Disable Bluetooth under Mac OS X}
#
# \implements{macosxstig}{OSX00065 M6}%
# \implements{mlionstig}{OSX8-00-00060,OSX8-00-00065,OSX8-00-00080}%
# Disable and/or uninstall Bluetooth protocol on Macs.

class network::bluetooth::no::darwin {
    $exts = '/System/Library/Extensions'
    file {
        "${exts}/IOBluetoothFamily.kext":
            ensure => absent,
            force => true;
        "${exts}/IOBluetoothHIDDriver.kext":
            ensure => absent,
            force => true;
    }
}
