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
# \subsection{Set MCX values on the computer}
#
# The name must be in the format {\tt
# \emph{appDomain}/\emph{key1}[/\emph{key2}/\emph{key3}...] }.
#
# This defined resource type always uses the record \verb!/Computers/$::fqdn!
# as the place to set the key.
#
# Example:
# \begin{verbatim}
#     mcx::set { "com.apple.digihub/com.apple.digihub.cd.music.appeared":
#         mcx_domain => 'always',
#         value => 1,
#     }
# \end{verbatim}
# \dinkus

define mcx::set($mcx_domain='always', $value, $ensure='present') {
    require mcx::prepare

    mac_mcx_plist_value { "/Computers/${::fqdn}:${name}":
        mcx_domain => $mcx_domain,
        value => $value,
        ensure => $ensure,
    }
}
