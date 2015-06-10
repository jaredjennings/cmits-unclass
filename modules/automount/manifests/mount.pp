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
# \subsection{NFS mounts}
#
# To make sure of a certain filesystem being mounted, call this define like so:
#
# {\tt automount::mount \{ \emph{name}: from => "\emph{nfs path}" \}}
#
# For example, {\tt automount::mount \{ "home": from =>
# "myfiler:/export/home" \}} would make sure that \verb!myfiler!'s
# \verb!/export/home! share is mounted as \verb!/net/home!.
#
# To remove an automount entry:
#
# {\tt automount::mount \{ \emph{name}:
#      from => "\emph{nfs path}",
#      ensure => absent
# \}}
#
# If you have additional mount options (such as you would give to
# \verb!mount(1)!'s \verb!-o! switch), give them in an array as the
# options parameter. For example:
#
# {\tt automount::mount \{ 'home':
#      from => 'myfiler:/export/home',
#      options => ['nolocks','nordirplus'],
# \}}
#
# The options given in the options parameter may be inside multiple
# levels of arrays; this is so that you can create layers of
# abstraction above this define. The set of available options varies
# from platform to platform, and the behavior when an unknown option
# is supplied may also vary.
#
#
# \dinkus

define automount::mount($from, $under='', $ensure='present', $options=[]) {
    include automount

    case $::osfamily {
        'redhat': {
            automount::mount::redhat { $name:
                from => $from,
                under => $under,
                ensure => $ensure,
                options => $options,
            }
        }
        'darwin': {
            automount::mount::darwin { $name:
                from => $from,
                under => $under,
                ensure => $ensure,
                options => $options,
            }
        }
        default: { unimplemented() }
    }
}
