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
Facter.add("gateway") do
    confine :kernel => :Linux
    setcode do
        output = Facter::Util::Resolution.exec('/sbin/ip r')
        if output.nil?
            nil
        else
            lines = output.split("\n")
            rv = nil
            lines.grep(/^default/).each do |dline|
                dline.chomp!
                # "default via xxx.xxx.xxx.xxx ..."
                rv = dline.split(' ')[2]
            end
            rv
        end
    end
end
