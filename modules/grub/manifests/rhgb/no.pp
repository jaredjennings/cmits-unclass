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
# \subsubsection{Disable Red Hat graphical boot}
# This is so that the video driver will certainly not be in use at boot time,
# so we can install the NVIDIA driver if necessary.

class grub::rhgb::no {
    $g = "/boot/grub/grub.conf"
    exec { "disable_rhgb_kernel_cmdlines":
        path => "/bin:/sbin",
        onlyif => "grep '^[[:space:]]*kernel' $g | \
                   grep -v rhgb >&/dev/null",
        command => "sed -i.disable_rhgb -e \
                    '/[[:space:]]*kernel/s/\\<rhgb\\>//' $g",
        logoutput => true,
    }
}
