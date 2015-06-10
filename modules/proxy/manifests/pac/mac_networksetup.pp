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
# \subsubsection{Set proxy autoconfiguration URL on Macs using networksetup}

class proxy::pac::mac_networksetup($url) {

# Examples of network services are \verb!Ethernet! and \verb!AirPort!.
    $networkservice = 'Ethernet'

    exec { 'set Mac autoproxyurl':
        unless => "networksetup -getautoproxyurl ${networkservice} | \
                   grep \"URL: ${url}\"",
        command => "networksetup -setautoproxyurl ${networkservice} ${url}",
    }

    exec { 'enable Mac autoproxy':
        onlyif => "networksetup -getautoproxyurl ${networkservice} | \
                   grep \"Enabled: no\"",
        command => "networksetup -setautoproxystate ${networkservice} on",
    }
}