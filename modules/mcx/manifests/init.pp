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
# \section{MCX}
# 
# Manage per-user or per-computer settings on Macs using MCX (acronym expansion
# unknown).
#
# Puppet provides an \verb!mcx! resource type, which ``manages the entire
# MCXSettings attribute available to some directory services nodes.'' According
# to
# \href{https://groups.google.com/d/msg/puppet-users/aYU7fZU6tw8/9ybJTePGnYgJ}{a
# mailing list message from October 2009}, this is because there are ``many
# nested values that would be impossible to neatly specify in the puppet DSL.'' 
# The best guide so far for how to manage MCX using the \verb!mcx! resource
# type is at
# \url{http://flybyproduct.carlcaum.com/2010/03/managing-mcx-with-puppet-on-snow.html}.
#
# With all that said, this module does not use the \verb!mcx! resource type:
# here we try to manage in more detail, so that settings needed for one reason
# or another can be written in the place in this \CMITSPolicy\ where they
# logically belong, rather than being jumbled together into one big pot of
# settings.
