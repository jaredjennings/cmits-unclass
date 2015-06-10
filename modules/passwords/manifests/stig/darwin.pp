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
# \subsubsection{Passwords on Macs}

class passwords::stig::darwin {

# \implements{macosxstig}{GEN000800 M6}%
# Prohibit the use of any of the last fifteen passwords as the next password on
# Macs.
    global_pwpolicy { 'usingHistory': value => 15 }
# \implements{macosxstig}{OSX00020 M6}%
# Set a maximum password age on Macs.
#
# 86400 minutes is 60 days.
    global_pwpolicy { 'maxMinutesUntilChangePassword':
        value => 86399,
    }
# \implements{macosxstig}{OSX00030 M6}%
# \implements{mlionstig}{OSX8-00-00590}%
# Set a minimum password length for Macs.
    global_pwpolicy { 'minChars': value => 15 }
# \implements{macosxstig}{OSX00036 M6}%
# Require alphabetic characters in passwords on Macs.
    global_pwpolicy { 'requiresAlpha': value => true }
# \implements{macosxstig}{OSX00038 M6}%
# Require symbols in passwords on Macs.
    global_pwpolicy { 'requiresSymbol': value => true }
# \implements{macosxstig}{OSX00040 M6}%
# Prohibit names from being used as passwords on Macs.
    global_pwpolicy { 'passwordCannotBeName': value => true }
# \implements{mlionstig}{OSX8-00-001325}%
# Unlock users after 15 minutes when they have locked themselves out
# with bad password attempts.
#
# Note that this contravenes the earlier Snow Leopard requirement
# \macosxstig{OSX00045 M6}.
    global_pwpolicy { 'minutesUntilFailedLoginReset': value => 15 }
# \implements{macosxstig}{OSX00050 M6}%
# Set the maximum number of failed login attempts on the Mac.
    global_pwpolicy { 'maxFailedLoginAttempts': value => 3 }

# \implements{mlionstig}{OSX8-00-00630}%
# Disable the password hint field.
    mcx::set { 'com.apple.loginwindow:RetriesUntilHint':
        value => 0,
    }
}
