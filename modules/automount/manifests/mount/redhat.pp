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
# \subsection{Adding an automount entry under Red Hat}
#
# Don't use this directly: use \verb!automount::mount! and let it sort out what
# platform you are on. Documentation is above.

define automount::mount::redhat($from, $under='', $ensure='present', $options=[]) {
    include augeas

    $hostpath = split($from, ':')
    $host = $hostpath[0]
    $path = $hostpath[1]

# \implements{unixsrg}{GEN002420,GEN005900} Ensure the \verb!nosuid! option
# is used when mounting an NFS filesystem.
#
# \implements{unixsrg}{GEN002430} Ensure the \verb!nodev! option is used when
# mounting an NFS filesystem.
    $stig_required = "
set \$here/opt[last()+1] nosuid
set \$here/opt[last()+1] nodev
"

    $extra = inline_template("
<% @options.flatten.each do |o| %>
set \$here/opt[last()+1] '<%=o%>'
<% end %>
")

# (The comments in the stock /etc/auto.master make it seem that these may be
# defaults under the conditions where we are using the automounter; but, better
# safe than sorry.)
#
# Under RHEL5, the default was to use TCP for NFS mounts, according to
# \verb!nfs(5)!; under RHEL6 the default is to try to autonegotiate. Without
# any deeper investigation, it is apparent that this process does not work, and
# specifying \verb!proto=tcp! makes it work properly. See \verb!nfs(5)! under
# RHEL6 for more details.
    $base_options = "
set \$here/opt[last()+1]     nfsvers
set \$here/opt[last()]/value 3
set \$here/opt[last()+1]     proto
set \$here/opt[last()]/value tcp
"


    $set_values_script = "
set \$here '${name}'
rm  \$here/opt
${base_options}
${stig_required}
${extra}
rm  \$here/location
set \$here/location/1/host ${host}
set \$here/location/1/path ${path}
"

    if $under == '' {
        $autotable = '/etc/auto.net'
        $requires = []
    }
    else {
        $autotable = "/etc/auto.${under}"
        if !defined(Automount::Mount::Redhat::Subdir[$under]) {
            automount::mount::redhat::subdir { $under:
                ensure => $ensure,
            }
        }
        if !defined(Automount::Mount::Redhat[$under]) {
            automount::mount::redhat { $under:
                ensure => absent,
                from => 'nonce:/dontmatter',
            }
        }
        $requires = [Automount::Mount::Redhat::Subdir[$under],
            Automount::Mount::Redhat[$under]]
    }

    Augeas {
        lens => 'Automounter.lns',
        incl => $autotable,
        context => "/files${autotable}",
        require => [
            File[$autotable],
            Package["autofs"],
            $requires,
            ],
        notify => Service['autofs'],
    }
    case $ensure {
        'present': {
            augeas { "create_mount_${under}_${name}":
                onlyif => "match *[.='$name'] size == 0",
                changes => "
defnode here 999 ${name}
${set_values_script}
",
            }
            augeas { "modify_mount_${under}_${name}":
                onlyif => "match *[.='$name'] size > 0",
                changes => "
defnode here *[.='${name}'] ${name}
${set_values_script}
",
            }
        }
        'absent': {
            augeas { "no_mount_${under}_${name}":
                changes => [
                    "rm *[.='$name']",
                ],
            }
        }
    }
}
