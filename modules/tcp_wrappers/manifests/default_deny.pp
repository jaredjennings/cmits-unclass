# % CMITS - Configuration Management for Information Technology Systems
# % Based on <https://github.com/afseo/cmits>.
# % Copyright 2015 Jared Jennings <mailto:jjennings@fastmail.fm>.
# %
# % Licensed under the Apache License, Version 2.0 (the "License");
# % you may not use this file except in compliance with the License.
# % You may obtain a copy of the License at
# %
# %    http://www.apache.org/licenses/LICENSE-2.0
# %
# % Unless required by applicable law or agreed to in writing, software
# % distributed under the License is distributed on an "AS IS" BASIS,
# % WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# % See the License for the specific language governing permissions and
# % limitations under the License.
# \subsection{Deny incoming connections by default}
#
# Any incoming connections controlled by TCP wrappers, which are not explicitly
# allowed, should be denied.

class tcp_wrappers::default_deny {
# We don't need custom Augeas lenses here; but they are needed to
# write things in the \verb!hosts.allow! file, so if we don't have
# them, and we write the \verb!hosts.deny!, nothing will be allowed.
    require augeas
    file { "/etc/hosts.deny":
        owner => root, group => 0, mode => 0644,
        content => "# Deny by default\nALL: ALL\n";
    }
}
