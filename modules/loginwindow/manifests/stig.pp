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
# \subsection{STIG-required login window configuration}

class loginwindow::stig {

    $lw_domain = "/Library/Preferences/com.apple.loginwindow"

# \implements{macosxstig}{OSX00310 M6}%
# Configure the Mac login window to show username and password prompts, not a
# ``list of local user names available for logon.''
    mac_default { "$lw_domain:SHOWFULLNAME":
        type => int,
        value => 1,
    }

# \implements{macosxstig}{OSX00325 M6}%
# Disable password hints in the Mac login window.
    mac_default { "$lw_domain:RetriesUntilHint":
        type => int,
        value => 0,
    }

# \implements{macosxstig}{OSX00425 M6}%
# Disable automatic login on Macs.
    mac_default { "$lw_domain:autoLoginUser":
        ensure => absent,
    }
}
