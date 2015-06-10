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

Puppet::Type.newtype(:mac_automount) do
    @doc = <<-EOT
        Manage NFS automounts on Macs.

        On a Mac, NFS automounts are configured as items in the Open Directory
        under /NFS.

        Example:
        
            mac_automount { '/net/bla':
                source => 'nfsfiler.example.com:/vol/bla',
                options => ['nodev', 'nosuid'],
                ensure => present,
            }
    EOT

    ensurable do
        defaultvalues
        defaultto :present
    end

    newparam(:mountpoint) do
        desc "The absolute path in the filesystem where the NFS mount will appear."
        isnamevar
        isrequired
        newvalues /^\/.*$/
    end

    newparam(:source) do
        desc "The source of the NFS mount."
        isrequired
    end

    newparam(:options) do
        desc "The options with which to do the mount. See mount(8)."
        munge do |value|
            if value.is_a? Array
                value.flatten
            else
                [value]
            end
        end
    end
end
