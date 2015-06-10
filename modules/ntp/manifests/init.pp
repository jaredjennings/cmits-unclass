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
# \section{NTP}
# \label{ntp}
#
# Configure the Network Time Protocol (NTP) service.
#
# \implements{unixsrg}{GEN000241} On all networks where timeservers exist,
# use \verb!ntpd! to keep continuous synchronization with the timeservers.
#
# Here is some background regarding NTP implementation interoperability as it
# relates to cryptographic authentication of time data:
#
# According to \cite{ms-sntp}, \S 1, time services on Windows support a subset
# of NTPv3 (\cite{rfc1305}), not NTPv4 (\cite{rfc5905}, \cite{rfc5906}), and \S
# 3.2.5.1 says, ``[T]he authentication mechanism defined in RFC 1305 Appendix
# C.1 is not supported.'' This means that Windows time services support neither
# the symmetric key authentication of NTPv3 nor the Autokey of NTPv4 as
# cryptographic means of authenticating time data, but only support the
# Microsoft-proprietary means of time data authentication within the context of
# an Active Directory domain. These proprietary extensions to NTP are not
# supported by the NTP software used in RHEL 5 and 6, which is the reference
# implementation of NTPv4 from the University of Delaware.

class ntp {
    include "ntp::${::osfamily}"
}
