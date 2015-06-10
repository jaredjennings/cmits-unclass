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
# \subsection{Disable WiFi on Macs}

class network::wifi::no::darwin {

# \implements{macosxstig}{OSX00060 M6}%
# Disable Wi-Fi on Macs by removing the driver files that support it.
    $exts = '/System/Library/Extensions'
    file { "${exts}/IO80211Family.kext":
        ensure => absent,
        force => true,
    }

    $nse = 'networkserviceenabled'
    exec { 'disable AirPort network service':
        command => 'networksetup -set${nse} AirPort off',
        onlyif => 'networksetup -get${nse} | grep Enabled',
    }
    exec { 'disable Wi-Fi network service':
        command => 'networksetup -set${nse} Wi-Fi off',
        onlyif => 'networksetup -get${nse} | grep Enabled',
    }

# \implements{macosxstig}{OSX00385 M6}%
# Turn off AirPort power on Macs if ``unused.''
#
# This one is a little tricky because you have to give a network
# interface name, not a network service name. And it's theoretically
# possible for a network service to own multiple interfaces.
    exec { 'turn off AirPort power':
# So---if any Wi-Fi or AirPort devices have power On...
        onlyif => "\
              networksetup -listnetworkserviceorder | \
              grep -A1 'Wi-Fi\\|AirPort' | \
              grep -o 'Device: [a-z0-9]\\+' | \
              cut -d: -f2 | \
              xargs -n 1 networksetup -getairportpower | \
              grep 'On\$'",
# ...turn off power to all Wi-Fi or AirPort devices.
        command => "\
              networksetup -listnetworkserviceorder | \
              grep -A1 'Wi-Fi\\|AirPort' | \
              grep -o 'Device: [a-z0-9]\\+' | \
              cut -d: -f2 | \
              xargs -I % networksetup -setairportpower % Off",
    }

This is done using System Preferences. Open the Network section;
for each active AirPort interface in the pane on the left, click the
interface, and click ``Turn AirPort Off.'' After all of this, click
``Apply.''

This is done using System Preferences.
\doneby{admins}{macosxstig}{OSX00400 M6}%
Turn off IPv6 on Macs ``if not being used.''

This is done using System Preferences. Open the Network section;
for each active interface in the pane on the left, click the interface,
click the ``Advanced...'' button toward the lower right, and in the TCP/IP
tab, change the ``Configure IPv6'' setting to ``Off.'' After all of this,
click ``Apply.''
}
