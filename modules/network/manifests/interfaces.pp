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
# \subsection{Interfaces}
#
# Use Facter to figure out which interfaces we're using. Assume the first one
# is the one we should configure. Facter takes care of filtering out \verb!lo!,
# the loopback interface.
class network::interfaces {
# The \verb!$interfaces! variable is a string with all the interfaces separated
# by commas. First turn it into an array...
    $all = split($interfaces,",")
# then pick out the first member.
    $first = $all[0]
}
