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

require 'etc'

Puppet::Type.type(:unowned).provide :ruby_etc do
    desc "Find 'unowned' files by using Ruby's Etc module, and fix them."

    # first hack, calls stat way too many times

    def owned_by_known_user
        stat = File.stat(@resource[:path])
        uid = stat.uid
        begin
            Etc.getpwuid uid
            true
        rescue ArgumentError
            # we do not know a name for this user
            false
        end
    end

    def groupowned_by_known_group
        stat = File.stat(@resource[:path])
        gid = stat.gid
        begin
            Etc.getgrgid gid
            true
        rescue ArgumentError
            # we do not know a name for this user
            false
        end
    end

    def name2uid name_or_number
        case name_or_number
        when Integer, Fixnum, Bignum; name_or_number
        else Etc.getpwnam(name_or_number).uid
        end
    end

    def name2gid name_or_number
        case name_or_number
        when Integer, Fixnum, Bignum; name_or_number
        else Etc.getgrnam(name_or_number).gid
        end
    end

    def owner
        File.stat(@resource[:path]).uid
    end

    def group
        File.stat(@resource[:path]).gid
    end

    def owner= newvalue
        stat = File.stat(@resource[:path])
        gid = stat.gid
        File.chown newvalue, gid, @resource[:path]
    end

    def group= newvalue
        stat = File.stat(@resource[:path])
        uid = stat.uid
        File.chown uid, newvalue, @resource[:path]
    end
end
