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
Facter.add("broadcast") do
    confine :kernel => :Linux
    setcode do
        my_ip_regex = Regexp.new(Regexp.escape("inet #{Facter.ipaddress}"))
        output = Facter::Util::Resolution.exec('/sbin/ip a')
        if output.nil?
            nil
        else
            lines = output.split("\n")
            rv = nil
            lines.grep(my_ip_regex).each do |bline|
                words = bline.split(' ')
                rv = words[3] if words[2] == 'brd'
            end
            rv
        end
    end
end
