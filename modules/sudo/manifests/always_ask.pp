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
# \subsection{Always ask for password when sudoing}

class sudo::always_ask {
# The check content in the STIG says to look for these two ``Defaults'' lines
# in \verb!/etc/sudoers!; we have written them in a file under
# \verb!/etc/sudoers.d! instead. So while we are compliant, the check as it
# stands will fail.
#
# \implements{macosxstig}{OSX00110 M6}%
# Always ask for passwords when people use sudo.
#
# The Rule Title here does not correctly summarize what the Vulnerability
# Discussion, Check Content and Fix Text describe.
    sudo::policy_file { 'always_ask':
        content => "
Defaults tty_tickets
Defaults timestamp_timeout=0
",
    }
}
