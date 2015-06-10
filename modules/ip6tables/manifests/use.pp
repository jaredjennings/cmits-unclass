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
# To apply a set of ip6tables rules to a given host (node), first know the
# network and broadcast addresses of the node, and its default gateway. In this
# example we'll say the site is allocated a /48 prefix, and the host has IPv6
# address 2001:DB8:0:3::16. The subnet's address is 2001:DB8:0:3::/64, and the
# whole site's address is 2001:DB8:0::/48. (See
# \href{http://tools.ietf.org/html/rfc3849}{RFC 3849}.) Then you would write:
#
# \begin{verbatim}
#     ip6tables::use { "mytemplate":
#         subnet => "2001:DB8:0:3::/64",
#         site   => "2001:DB8:0::/48",
#     }
# \end{verbatim}
#
# where \verb!mytemplate! is the name of a file in
# \verb!modules/ip6tables/templates! in this policy. \verb!site! is used for
# rules which deal with traffic within a site's (possibly multiple) networks,
# such as SSH connections or pings. 

define ip6tables::use($subnet, $site) {
    include ip6tables
    $ipt_text = template("ip6tables/${name}")
    file { "/etc/sysconfig/ip6tables":
        owner => root, group => 0, mode => 0600,
        content => $ipt_text,
        notify => Service["ip6tables"],
    }
}
