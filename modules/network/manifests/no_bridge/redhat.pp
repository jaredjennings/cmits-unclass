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
class network::no_bridge::redhat {
# Make sure we have \verb!brctl!.
    package { "bridge-utils":
        ensure => present,
    }
# Use it to make sure there are no bridges in operation.
    exec { "no_bridges":
        path => "/bin:/sbin:/usr/bin:/usr/sbin",
# \verb!brctl show! always shows a header; skip it. After that, if there are
# any lines of output, we have a situation.
        onlyif => "test `brctl show | tail -n +2 | wc -l` -ne 0",
        command => "echo ETHERNET BRIDGING CONFIGURED; \
                    brctl show",
        logoutput => true,
        loglevel => err,
    }
}
