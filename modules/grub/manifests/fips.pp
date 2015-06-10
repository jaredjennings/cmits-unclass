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
# \subsection{Enable FIPS-compliant kernel mode}
#
# See \S\ref{class_fips}.

class grub::fips {
    $g = "/boot/grub/grub.conf"
    exec { "fipsify_kernel_cmdlines":
        path => "/bin:/sbin",
        onlyif => "grep '^[[:space:]]*kernel' $g | \
                   grep -v fips=1 >&/dev/null",
        command => "sed -i.fips -e \
            '/^[[:space:]]*kernel/s/\$/ fips=1/' $g",
        logoutput => true,
    }
# Warning: this probably won't work right with EFI. See \url{https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Security_Guide/chap-Federal_Standards_and_Regulations.html}.
    exec { "bootify_kernel_cmdlines":
        path => '/bin:/sbin',
        onlyif => "grep '^[[:space:]]*kernel' $g | \
                   grep -v boot=${::boot_filesystem_device} \
                       >&/dev/null",
        command => "sed -i.fips2 -e \
            '/^[[:space:]]*kernel/s!\$! boot=${::boot_filesystem_device}!' $g",
        logoutput => true,
    }
}
