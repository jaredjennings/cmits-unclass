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
# \subsection{Enable serial console}
#
# See \S\ref{class_serial_console}.

class grub::serial_console($speed=9600) {

# First, make all the kernels treat the serial port as the console.
    $g = "/boot/grub/grub.conf"
    exec { "serial_console_ify_kernel_cmdlines":
        path => "/bin:/sbin",
        onlyif => "grep '^[[:space:]]*kernel' $g | \
                   grep -v console=ttyS0,${speed}n8 >&/dev/null",
        command => "sed -i.serial_console_kernels -e \
            '/[[:space:]]*kernel/s/\$/ console=tty console=ttyS0,${speed}n8 /' $g",
        logoutput => true,
    }

# Then, make grub itself treat the serial port as the console.
#
# Regarding the terminal command: "When both the serial port and the attached
# monitor and keyboard are configured they will both ask for a key to be
# pressed until the timeout expires. If a key is pressed then the boot menu is
# displayed to that device.  Disconcertingly, the other device sees nothing."

    exec { "serial_console_ify_grub":
        path => "/bin:/sbin",
        unless => "grep ^serial $g",
        command => "sed -i.serial_console_grub -e \
            '/[[:space:]]*default/i \\\n\
serial --unit=0 --speed=${speed} \
 --word=8 --parity=no --stop=1\\\n\
terminal --timeout=10 serial console\n\
' $g",
        logoutput => true,
    }
}
