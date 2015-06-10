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
# \subsection{Install a PolicyKit rule}
#
# This defined resource type is for system mandatory rules for PolicyKit 0.96
# as used in RHEL6.
#
# As an example, one of the things PolicyKit enables is for non-root users to
# change network settings, so that desktop users, who are not computer
# administrators by trade, can connect to wireless networks without the
# security risks involved in becoming root. But
# (see~\S\ref{module_networkmanager}) as a matter of compliance we may want to
# get rid of that ability. You could do so like this:
#
# \begin{verbatim}
#     policykit::mandatory_rule { 'network-admin-auth':
#         description => "only admins can change network",
#         identity => '*',
#         action => "org.freedesktop.NetworkManager.*;\
# org.freedesktop.network-manager-settings.*",
#     }
# \end{verbatim}
#
# The values you provide are written directly in a PolicyKit local authority
# file; the syntax is written in \verb!pklocalauthority(8)!. The default result
# provided by this type is \verb!auth_admin!, because that's what security
# documents are most likely to require.
#
# There is also much in \verb!pklocalauthority(8)! about how rules combine, and
# which rules win. Go read it.

define policykit::rule(
        $description,
        $identity,
        $action,
        $result_any="auth_admin",
        $result_active="auth_admin",
        $result_inactive="auth_admin",
        $order="50",
        $rule_directory="/etc/polkit-1/\
localauthority/90-mandatory.d",
        ) {

    if     ($::osfamily == 'RedHat') and
           ($::operatingsystemrelease =~ /^6\..*/) {

# RHEL6 uses PolicyKit.

        if $::policykit_installed == 'true' {
            file { "${rule_directory}/\
${order}-cmits-${name}.pkla":
                owner => root,
                group => 0,
                mode => 0600,
                content => "\
[$description]\n\
Identity=$identity\n\
Action=$action\n\
ResultAny=$result_any\n\
ResultActive=$result_active\n\
ResultInactive=$result_inactive\n",
            }
        } else {
# If PolicyKit is not installed (e.g., on a server), the directory tree where
# this file belongs will not exist---and there won't be any point installing
# the file, either, because without PolicyKit, normal users cannot do whatever
# this rule is limiting. So we do nothing, with no error.
        }
    } else {
# Other operating systems besides RHEL6 may not come with PolicyKit, or may
# come with a much different version of it. The details above don't make sense
# for any other OS than RHEL6, so we won't bother dealing with other OSes on a
# case-by-case basis here.
        unimplemented()
    }
}
