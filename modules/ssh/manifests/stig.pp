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
# \subsection{STIG-required SSH configuration}
#
# \implements{unixsrg}{GEN005504}%
# Configure the SSH daemon to listen on addresses other than management network
# addresses, because it is ``authorized for uses other than management'' here.
#
# Either \verb!ssh::gssapi! or \verb!ssh::no_gssapi! must also be included for
# STIG compliance.

class ssh::stig {
    include ssh
    include ssh::fips
    include ssh::no_tunnelling
    include ssh::stig_palatable
}
