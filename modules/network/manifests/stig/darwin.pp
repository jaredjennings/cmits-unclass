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
# \subsection{STIG-required network configuration under Mac OS X}

class network::stig::darwin {
# First ensure that sysctl.conf exists; the STIG implies that it may not.
#
# \index{FIXME}%
# For least surprise for policy maintainers, this should probably go in a more
# generic module than ``network.''
    file { '/etc/sysctl.conf':
        ensure => present,
        owner => root, group => 0, mode => 0644,
    }
# All of our edits will be to sysctl.conf.
    Augeas {
        context => "/files/etc/sysctl.conf",
    }

    augeas {
# \implements{macosxstig}{GEN003602 M6}%
# \implements{mlionstig}{OSX8-00-01220}%
# Configure the system to block ICMP timestamp requests.
        "block_icmp_timestamp_requests":
            changes => "set net.inet.icmp.timestamp 1";
# \implements{macosxstig}{GEN003603 M6}%
# \implements{mlionstig}{OSX8-00-01190}%
# Configure the system to ignore ICMP pings sent to a broadcast address.
        "ignore_icmpv4_broadcast_echoreq":
            changes => "set net.inet.icmp.bmcastecho 1";
# \implements{macosxstig}{GEN003606 M6}%
# \implements{mlionstig}{OSX8-00-01215}%
# Configure the system to ``prevent local applications from generating
# source-routed packets.''
        "prevent_outgoing_source_routing":
            changes => "set net.inet.ip.sourceroute 0";
# \implements{macosxstig}{GEN003607 M6}%
# \implements{mlionstig}{OSX8-00-01195}%
# Configure the system to ``not accept source-routed IPv4 packets.''
        "reject_ipv4_source_routed":
            changes => "set net.inet.ip.accept_sourceroute 0";
# \implements{macosxstig}{GEN003609 M6}%
# \implements{mlionstig}{OSX8-00-01200}%
# Configure the system to ``ignore ICMPv4 redirect messages.''
#
# A typo in the earlier Mac OS X stig said to make this 0.
        "ignore_icmpv4_redirects":
            changes => "set net.inet.icmp.drop_redirect 1";
# \implements{macosxstig}{GEN003610 M6}%
# \implements{mlionstig}{OSX8-00-01210}%
# Prevent the system from sending ICMPv4 redirect messages.
        "dont_send_icmpv4_redirects":
            changes => "set net.inet.ip.redirect 0";
    }
    include network::ike::no
}
