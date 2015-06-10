# CMITS - Configuration Management for Information Technology Systems
# Based on <https://github.com/afseo/cmits>.
# Copyright 2015 Jared Jennings <mailto:jjennings@fastmail.fm>.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
Facter.add("boot_filesystem_device") do
  confine :kernel => "Linux"
  setcode do
    # http://stackoverflow.com/questions/7718411
    st = File.stat('/boot')
    expected = "#{st.dev_major}:#{st.dev_minor}\n"
    boot_devdir = Dir['/sys/class/block/*'].find do |devdir|
      File.read(File.join(devdir, 'dev')) == expected
    end
    dev_now = File.join('/dev', File.basename(boot_devdir))
    # Now, as per
    # https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Security_Guide/chap-Federal_Standards_and_Regulations.html
    # we should take care because the device name at the next boot may
    # be different than it is now: perhaps the drives were shuffled
    # around or some such. By getting and returning the filesystem
    # UUID instead, the kernel can locate the filesystem in the future
    # boot environment, no matter what device it may be on then.
    Facter::Util::Resolution.exec("/sbin/blkid -o export #{dev_now}").split("\n")[0]
  end
end

