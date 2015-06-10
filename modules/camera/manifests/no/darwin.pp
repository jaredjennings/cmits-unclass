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
# \subsubsection{Disable cameras under Mac OS X}

class camera::no::darwin {
    $exts = '/System/Library/Extensions'
    $usbp = "${exts}/IOUSBFamily.kext/Contents/PlugIns"
    file {
# Disable ``support for internal iSight cameras.''
        "${exts}/Apple_iSight.kext":
            ensure => absent,
            force => true;
# Disable ``support for external cameras.''
        "${usbp}/AppleUSBVideoSupport.kext":
            ensure => absent,
            force => true;
    }

# \implements{mlionstig}{OSX8-00-00465}%
# Remove the Photo Booth application.
    file { '/Applications/Photo Booth.app':
        ensure => absent,
        recurse => true,
    }

# \implements{mlionstig}{OSX8-00-00475}%
# Remove the FaceTime application.
    file { '/Applications/FaceTime.app':
        ensure => absent,
        recurse => true,
    }

# \implements{mlionstig}{OSX8-00-00495}%
# Remove the Image Capture application.
    file { '/Applications/Image Capture.app':
        ensure => absent,
        recurse => true,
    }
}
