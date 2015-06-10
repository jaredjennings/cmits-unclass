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

Puppet::Type.newtype(:global_pwpolicy) do
    @doc = "Deal with global password policy on Macs.
    Example:

        global_pwpolicy { 'usingHistory': value => 15 }
    
    Changing password policy on a remote host is not supported by this type.
    "
    newparam(:name) do
        desc "The name of a global password policy parameter, written in camelCase, just as listed in pwpolicy(8)."
        isnamevar
    end

    newproperty(:value) do
        desc "The value of the global password policy item named by the name parameter.
        Some password policy values are either 0 or 1. You can specify true or
        false for these if you like. Some password policy values are dates.
        These you must specify as a string, 'mm/dd/yy', the same format that
        the pwpolicy utility expects."
    end
end
