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

Puppet::Type.type(:trac_permission).provide :trac_admin do
    desc <<-EOT
    
    Manage permissions in a Trac instance using the trac-admin command.

    There is a hardcoded assumption that all Trac instances live under
    /var/www/tracs, so that you can use puppet resource list to find the
    complete present configuration.

    Furthermore we assume when parsing the Trac permissions that actions do not
    contain spaces, but subjects may.

    EOT

    commands :trac_admin => "/usr/bin/trac-admin"

    # There was once code here to try to fetch instances of this provider so
    # that `puppet resource` could show Trac permissions existing on the
    # system; but that didn't work, and this parsing code is all that's still
    # needed to make the resource get and set Trac permissions.
    class << self
        def permissions_in instance_dir
            found = []
            out = trac_admin instance_dir, 'permission', 'list'
            lines = out.split("\n")
            # skip header
            lines[3..-1].each do |line|
                break if line == ""    # end of the permission table
                values = line.split
                if values.length > 1
                    action = values[-1]
                    subject = values[0..-2].join(' ')
                    found << [subject, action]
                else
                    warning "in Trac instance #{instance_dir}, " \
                            "cannot understand permission line " \
                            "#{line.inspect}"
                end
            end
            found
        end
    end

    def permissions_in instance_dir
        self.class.permissions_in instance_dir
    end

    def cartesian a, b
        # In Ruby 1.9, Arrays have a product method. But we may not be running
        # in Ruby 1.9.
        result = []
        a.each do |from_a|
            b.each do |from_b|
                result << [from_a, from_b]
            end
        end
        result
    end

    def needs_done
        all_users = permissions_in @resource[:instance]
        is = all_users.select {|s, a| @resource[:subject].include? s}
        should = cartesian(@resource[:subject], @resource[:action])
        to_add = should - is
        to_remove = is & should
        [to_add, to_remove]
    end

    def exists?
        to_add, to_remove = needs_done
        debug "to add: #{to_add.inspect}"
        debug "to remove: #{to_remove.inspect}"
        if @resource.deleting?
            to_remove.any?
        else
            to_add.empty?
        end
    end

    def create
        to_add, to_remove = needs_done
        to_add.each do |s, a|
            trac_admin @resource[:instance], 'permission', 'add', s, a
        end
    end

    def destroy
        to_add, to_remove = needs_done
        to_remove.each do |s, a|
            trac_admin @resource[:instance], 'permission', 'remove', s, a
        end
    end
end
