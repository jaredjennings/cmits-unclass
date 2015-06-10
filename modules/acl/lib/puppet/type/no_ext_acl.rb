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
Puppet::Type.newtype(:no_ext_acl) do
    @doc = "Make sure a file or directory has no extended ACL. There is no
support for setting the extended ACL here, only removing the whole thing.
Example usage:

    no_ext_acl { '/etc/ntp.conf': }
"
    ensurable do
        defaultvalues
        defaultto :present
    end
    newparam(:name) do
        desc "Name of the file or directory."
    end
    newparam(:recurse) do
        desc "Whether to recurse into children of a directory. (There is no provision for a recurselimit other than infinity.)"
        newvalues :true, :false
        defaultto :false
    end

end
