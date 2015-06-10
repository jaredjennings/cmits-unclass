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
# \subsection{Ask those logging in as root who they are}
#
# In order to preserve auditability even though \verb!root! is a group
# authenticator, ask users logging in as root who they are.
#
# Note that this has to be portable across all the platforms we use
# bash on.

class root::manual_audit {
    $bashrc = '/root/.bashrc'
    exec { 'add challenge 1 to root .bashrc':
        command => "sed -i.before_manual_audit -e '\$a \\
# % vvv puppet root::manual_audit 1 vvv\\
trap '\\'\\'' SIGINT\\
echo\\
echo \"Who are you and what are you doing?\"\\
echo \"Press Ctrl-D on an empty line when finished explaining.\"\\
sed '\\''s/[[:cntrl:]]/(CONTROL CHAR)/g'\\'' | \\\\\\
    logger -t \"ROOT LOGIN, user said\"\\
echo \"What you typed has been logged. Continuing.\"\\
trap - SIGINT\\
# % ^^^ puppet root::manual_audit 1 ^^^
' ${bashrc}",
        unless => "grep 'root::manual_audit 1 ' ${bashrc}",
        path => '/bin:/sbin',
    }
}
