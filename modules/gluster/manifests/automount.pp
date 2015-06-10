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
# \subsection{Gluster with Automount}
#
# As of 3.6.0.29-2.el6, \verb!glusterfs! when used with automount
# fails to mount the requested filesystem. If you turn up the
# debugging on autofs enough, you find this error:
#
# \begin{verbatim}
# /sbin/mount.glusterfs: line 13: /dev/stderr: Permission denied
# \end{verbatim}
#
# This boils down to an AVC denial. An SELinux module that allows the
# required behavior is provided here. Include the class to install the
# SELinux module.

class gluster::automount {
    require ::automount
    $selmoduledir = "/usr/share/selinux/targeted"
    file { "${selmoduledir}/gluster_automount.pp":
        owner => root, group => 0, mode => 0644,
        source => "puppet:///modules/gluster/\
gluster_automount.selinux.pp",
    }
    selmodule { "gluster_automount":
       ensure => present,
       syncversion => true,
       notify => Service['autofs'],
    }
}
