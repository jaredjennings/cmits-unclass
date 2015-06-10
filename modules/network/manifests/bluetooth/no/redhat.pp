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
# \paragraph{Disable Bluetooth under Red Hat}
#
# \implements{unixsrg}{GEN007660}%
# Disable and/or uninstall Bluetooth protocols. (Notably, this requirement
# does not say, ``unless needed.'')

class network::bluetooth::no::redhat {
    package {
        "gnome-bluetooth.x86_64":               ensure => absent;
        "gnome-bluetooth-debuginfo.i686":       ensure => absent;
        "gnome-bluetooth-debuginfo.x86_64":     ensure => absent;
        "gnome-bluetooth-libs-devel.i686":      ensure => absent;
        "gnome-bluetooth-libs-devel.x86_64":    ensure => absent;
        "pulseaudio-module-bluetooth.x86_64":   ensure => absent;
        "bluez.x86_64":                         ensure => absent;
        "bluez-alsa.i686":                      ensure => absent;
        "bluez-alsa.x86_64":                    ensure => absent;
        "bluez-compat.x86_64":                  ensure => absent;
        "bluez-libs-devel.i686":                ensure => absent;
        "bluez-libs-devel.x86_64":              ensure => absent;
        "bluez-cups.x86_64":                    ensure => absent;
        "bluez-gstreamer.i686":                 ensure => absent;
        "bluez-gstreamer.x86_64":               ensure => absent;
        "bluez-utils.i686":                     ensure => absent;
        "bluez-utils.x86_64":                   ensure => absent;
        "gvfs-obexftp.x86_64":                  ensure => absent;
        "obex-data-server.x86_64":              ensure => absent;
        "obexd.x86_64":                         ensure => absent;
    }
    kernel_module {
        "bnep":      ensure => absent;
        "rfcomm":    ensure => absent;
        "hidp":      ensure => absent;
        "bluetooth": ensure => absent;
        "cmtp":      ensure => absent;
        "sco":       ensure => absent;
        "l2cap":     ensure => absent;
    }
# ``Unprivileged local processes may be able to cause the system to dynamically
# load a protocol handler by opening a socket using the protocol.'' (SRG
# discussion) Prevent this by removing related kernel module files.
    file {
        "/lib/modules/$kernelrelease/kernel/net/bluetooth":
            ensure => absent,
            recurse => true,
            recurselimit => 2,
            force => true,
    }
}
