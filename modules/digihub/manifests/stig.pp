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
# \section{STIG-required digihub configuration}

class digihub::stig {

    $dh = 'com.apple.digihub'

# \implements{macosxstig}{OSX00340 M6}%
# \implements{mlionstig}{OSX8-00-00085}%
# Disable automatic actions when blank CDs are inserted.
#
# We don't strictly conform with the check and fix text here, because this is a
# Category I requirement, but the check and fix may only fix the systemwide
# default settings, not enforce the settings on everyone.
    mcx::set { "${dh}/${dh}.blank.cd.appeared":
        value => 1,
    }

# \implements{macosxstig}{OSX00341 M6}%
# \implements{mlionstig}{OSX8-00-00090}%
# Disable automatic actions when blank DVDs are inserted.
#
# Same as above.
    mcx::set { "${dh}/${dh}.blank.dvd.appeared":
        value => 1,
    }

# \implements{macosxstig}{OSX00345}%
# \implements{mlionstig}{OSX8-00-00095}%
# Disable automatic actions when music CDs are inserted.
#
# Here the STIG check and fix text have to do with setting things in the System
# Preferences GUI. With our MCX mechanism we are enforcing policies regarding
# these preferences; this is the only way to be sure because these preferences
# are stored and changed on a per-user basis, so setting the local admin user's
# preference to ``do nothing'' does not influence the value of any other user's
# preference. But setting the MCX policy forces the values of these preferences
# for everyone on the computer.
    mcx::set { "${dh}/${dh}.cd.music.appeared":
        value => 1,
    }

# \implements{macosxstig}{OSX00350 M6}%
# \implements{mlionstig}{OSX8-00-00100}%
# Disable automatic actions when picture CDs are inserted.
    mcx::set { "${dh}/${dh}.cd.picture.appeared":
        value => 1,
    }

# \implements{macosxstig}{OSX00355 M6}%
# \implements{mlionstig}{OSX8-00-00105}%
# Disable automatic actions when video DVDs are inserted.
    mcx::set { "${dh}/${dh}.dvd.video.appeared":
        value => 1,
    }
}
