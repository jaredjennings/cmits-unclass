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
# \subsection{Disable xinetd}
#
# \implements{unixsrg}{GEN003700}%
# Disable \verb!xinetd! if no services it provides are enabled.
#
# Note that the SRG does not say that \verb!xinetd! must always be disabled or
# uninstalled: but we aren't using it on any hosts controlled by this policy
# yet, so might as well uninstall it.

class stig_misc::xinetd {
    package { "xinetd": ensure => absent }
 #    service { "xinetd":
 #        ensure => stopped,
 #        enable => false,
 #    }
# Other packages may install files into \verb!/etc/xinetd.d! so even if
# \verb!xinetd! is not installed we still need to ensure ownership and
# permissions. Note that if we start using xinetd, we'll have to secure the
# \verb!xinetd.conf! file in addition to what's below.
#
# \implements{unixsrg}{GEN003720,GEN003730,GEN003740,GEN003750}%
# Control ownership and permissions of the \verb!xinetd! configuration.
    file { "/etc/xinetd.d":
        owner => root, group => 0, mode => 0440,
    }
# \implements{unixsrg}{GEN003745,GEN003755}%
# Remove extended ACLs on \verb!xinetd! configuration.
    no_ext_acl { "/etc/xinetd.d": }

# \notapplicable{unixsrg}{GEN003800}%
# If we remove xinetd, it doesn't matter whether it logs or traces because it
# doesn't do anything.

}

