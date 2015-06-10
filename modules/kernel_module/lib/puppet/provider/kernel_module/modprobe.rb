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

Puppet::Type.type(:kernel_module).provide :modprobe do
    desc "Remove extended ACLs using modprobe."

    commands :modprobe => "/sbin/modprobe"
    commands :lsmod => "/sbin/lsmod"

    def lsmod
        self.debug "Listing loaded kernel modules"
        stdin, stdout, stderr = Open3.popen3(command(:lsmod))
        stdin.close
        out = stdout.read
        stdout.close
        err = stderr.read
        stderr.close
        raise Puppet::Error, err unless err.empty?
        lines = out.split("\n")
        unless lines.length > 1
            raise Puppet::Error, "unexpectedly short lsmod output" 
        end
        # [1..-1]: discard first (header) line
        words = lines[1..-1].map {|x| x.split}
        # we are only interested in the list of loaded modules - not in their
        # sizes or dependencies
        return words.map {|x| x[0]}
    end

    def exists?
        return lsmod.member? @resource[:name]
    end

    def destroy
        self.debug "Attempting to unload kernel module"
        stdin, stdout, stderr = Open3.popen3(
            command(:modprobe), '-r', @resource[:name])
        stdin.close
        out = stdout.read
        stdout.close
        err = stderr.read
        stderr.close
        raise Puppet::Error, err unless err.empty?
    end

    def create
        self.debug "Attempting to load kernel module"
        stdin, stdout, stderr = Open3.popen3(
            command(:modprobe), @resource[:name])
        stdin.close
        out = stdout.read
        stdout.close
        err = stderr.read
        stderr.close
        raise Puppet::Error, err unless err.empty?
    end
end
