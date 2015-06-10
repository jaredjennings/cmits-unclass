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
Puppet::Parser::Functions::newfunction(:unimplemented,
        :doc => "Complain that something is unimplemented on a certain OS and release. If you supply any strings as arguments, they are included in the error message.") do |vals|
    vals = vals.collect { |s| s.to_s }.join(" ") if vals.is_a? Array
    os = lookupvar('operatingsystem')
    ver = lookupvar('operatingsystemrelease')
    message = "Unimplemented on #{os} release #{ver}"
    if vals != ""
        message << ": #{vals}"
    end
    function_crit [message]
    fail "#{scope_path[0].to_s}: #{message}"
end

