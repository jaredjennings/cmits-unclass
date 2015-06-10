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
# To apply a set of iptables rules to a given host (node), first know the
# network and broadcast addresses of the node, and its default gateway. In this
# example we'll say the host has IPv4 address 192.0.2.45. The network address
# is 192.0.2.0/25; the corresponding broadcast address is 192.0.2.127 (the
# address derived by turning on all the bits masked out by the netmask). The
# gateway in our example is 192.0.2.1. (See
# \href{http://tools.ietf.org/html/rfc5737}{RFC 5737}.) Then you would write:
#
# \begin{verbatim}
#     iptables::use { "amodule/mytemplate":
#         site_subnets => ["192.0.2.0/25"],
#         broadcast => "192.0.2.127",
#         gateway => "192.0.2.1",
#     }
# \end{verbatim}
#
# where \verb!mytemplate! is the name of a file in
# \verb!amodule/templates!, and \verb!amodule! is somewhere on Puppet's module
# path (e.g., in \verb!modules-unclass! or \verb!modules-fouo!).
# \verb!site_subnets! are used for rules which deal with traffic within a
# site's (possibly multiple) networks, such as SSH connections or pings.

define iptables::use($site_subnets, $broadcast, $gateway) {
    include iptables
    file { "/etc/sysconfig/iptables":
        owner => root, group => 0, mode => 0600,
        content => template("${name}"),
        notify => Service["iptables"],
# This previusly required xtables-addons; see Subversion revision
# 6550.
    }
}
