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
class sge::execd::darwin($sge_root, $cluster_name) {

    mac_launchd_file { 'net.sunsource.gridengine.sgeexecd':
        description => "The GridEngine execute daemon \
runs jobs submitted by users to GridEngine.",
        environment => {
            'SGE_ROOT'          => $sge_root,
            'SGE_CELL'          => 'default',
            'SGE_ND'            => 1,
            'DYLD_LIBRARY_PATH' => "$sge_root/lib/darwin-x86",
        },
        arguments => ["$sge_root/bin/darwin-x86/sge_execd"],
    }

    service { 'net.sunsource.gridengine.sgeexecd':
        enable => true,
        ensure => running,
        require => Mac_launchd_file['net.sunsource.gridengine.sgeexecd'],
        subscribe => Mac_launchd_file['net.sunsource.gridengine.sgeexecd'],
    }

    include shell::profile_d
    file { '/etc/profile.d/sge.sh':
        owner => root, group => 0, mode => 0644,
        content => "
export SGE_ROOT=${sge_root}
export SGE_CLUSTER_NAME=${cluster_name}
export PATH=\$SGE_ROOT/bin/darwin-x86:\$PATH
export DYLD_LIBRARY_PATH=\$SGE_ROOT/lib/darwin-x86\${DYLD_LIBRARY_PATH:+:\$DYLD_LIBRARY_PATH}
export MANPATH=\$MANPATH:\$SGE_ROOT/man
",
    }
}
