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
# \subsection{Disabling prelinking}

class prelink::no {
    package { 'prelink':
        ensure => installed,
    }
# The \verb!/etc/sysconfig/prelink! file says that \verb!prelink -ua! will be
# run the next night if \verb!PRELINKING! is set to no. This happens by means
# of \verb!/etc/cron.daily/prelink!.
#
# But in between now and then, if a reboot happens, we'll be running
# in FIPS mode without having un-prelinked the libraries. This will
# cause familiar and important parts of the system such as yum and ssh
# to break. So if and only if we've changed the above, we should go
# ahead and run \verb!prelink -ua! now.
    augeas { "disable_prelinking":
        context => "/files/etc/sysconfig/prelink",
        changes => "set PRELINKING no",
        notify => Exec['unprelink now'],
    }
    exec { 'unprelink now':
        command => '/usr/sbin/prelink -ua',
        refreshonly => true,
        require => Package['prelink'],
    }
}
