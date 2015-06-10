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
# \subsection{Avoid Ethernet bridging}
#
# \implements{unixsrg}{GEN003619} Do not configure network bridging.
#
# Warn if the system is configured for network bridging. (Removal of the bridge
# probably can't happen programmatically: it needs too much knowledge of the
# entire network configuration of a host.)

class network::no_bridge {
    include "network::no_bridge::${::osfamily}"
}
