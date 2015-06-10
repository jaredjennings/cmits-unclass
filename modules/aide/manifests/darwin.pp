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
# % This comment is here so that the unimplemented tag below will not
# % be the first non-empty Puppet comment in this file. Shaney puts a
# % \label{.../this_file.pp} after the first line of LaTeX code, but
# % since the unimplemented tag spans multiple lines, that puts the
# % label in the middle of it. That makes the LaTeX angry, and it
# % makes errors that aren't helpful in finding the problem.
#
# \unimplemented{mlionstig}{OSX8-00-01145}{We should watch setuid
# executables on the system. aide is the tool to do this. But we
# haven't implemented it on the Mac yet.}%
class aide::darwin {
    warning 'unimplemented for Macs'
}
