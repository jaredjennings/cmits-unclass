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
require 'open3'

Puppet::Type.type(:no_ext_acl).provide :macosx do
    desc "Remove extended ACLs using chmod, as under Mac OS X."

    commands :ls => "/bin/ls"
    commands :chmod => "/bin/chmod"
    confine :operatingsystem => :darwin
    defaultfor :operatingsystem => :darwin

    # See http://stackoverflow.com/questions/5387741
    def exists?
        output = execute [:ls, '-led', @resource[:name]], :combine => false
        # file with no ACL:
        # -rw-r--r--  1 jared  wheel  0 Feb  6 12:00 /tmp/bar
        # file with an ACL:
        # -rw-r--r--+ 1 jared  wheel  0 Feb  6 11:59 /tmp/foo
        return ! output.split('\n').grep(/^..........\+/).any?
    end

    def destroy
        raise Puppet::Error, "Cannot destroy a lack of an extended ACL"
    end

    def create
        debug "Deleting extended ACL and default ACL (if any)"
        if @resource[:recurse] == :true
            chmod '-R', '-N', @resource[:name]
        else
            chmod '-N', @resource[:name]
        end
    end
end
