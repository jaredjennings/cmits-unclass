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
require 'puppet'

Puppet::Type.type(:mac_autoupdate).provide :softwareupdate do
    desc "Manage automatic updates on a Mac using the softwareupdate command."

    commands :softwareupdate => "/usr/sbin/softwareupdate"
    confine :operatingsystem => :darwin
    defaultfor :operatingsystem => :darwin

    def enabled
        out = softwareupdate '--schedule'
        case out
        when "Automatic check is off\n"
            return :false
        when "Automatic check is on\n"
            return :true
        else
            fail "Unrecognized output from " \
                 "softwareupdate --schedule: #{out.inspect}"
        end
    end

    def enabled= newvalue
        case newvalue
        when :true
            softwareupdate '--schedule', 'on'
        when :false
            softwareupdate '--schedule', 'off'
        # else ... eh, do nothing
        end
    end
end
