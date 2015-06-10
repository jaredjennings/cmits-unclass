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
# \subsection{Use default USB mass storage permissions}
#
# Let the console user use USB mass storage, subject to defaults. Whenever the
# USB mass storage policy for a node or class is made less restrictive, you
# should replace the \verb!include usb::mass_storage::bla! class with an
# include for this class in that context.
class usb::mass_storage::default {
    file { "/etc/polkit-1/localauthority/90-mandatory.d/\
50-mil.af.eglin.afseo.admin-udisks.pkla":
        ensure => absent,
    }
}
