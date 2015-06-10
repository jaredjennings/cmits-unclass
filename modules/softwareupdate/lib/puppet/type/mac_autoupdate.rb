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

Puppet::Type.newtype(:mac_autoupdate) do
    @doc = <<-EOT
    Turn on and off automatic software updating on Macs.

    There can only be one of this resource in the manifest.
    EOT
    newparam(:name) do
        desc 'This must always be "auto".'
        newvalues "auto"
    end
    newproperty(:enabled) do
        desc "Whether automatic software updates should be enabled."
        newvalues :true, :false
        isrequired
    end
    validate do
        if not [:true, :false].include?(self[:enabled])
            fail "You must provide a true or false value for the enabled parameter"
        end
    end
end
