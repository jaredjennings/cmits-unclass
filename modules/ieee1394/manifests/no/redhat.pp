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
# \subsubsection{Under Red Hat}
# \implements{unixsrg}{GEN008500} Disable Firewire ``unless needed.'' We do not
# need it.

class ieee1394::no::redhat {
    kernel_module {
        "firewire-core": ensure => absent;
        "firewire-ohci": ensure => absent;
        "firewire-sbp2": ensure => absent;
        "firewire-net": ensure => absent;
    }
    file {
        "/lib/modules/$kernelrelease/kernel/drivers/firewire":
            ensure => absent, recurse => true,
            recurselimit => 1, force => true;
    }
}
# To reinstate IEEE 1394 support on a host which has previously had it
# disabled in the above manner, you must reinstall the kernel package and
# restart the host.
