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
# \subsection{Mail sent to root}
# \label{root_mail}
#
# Set the place where root's mail goes to. Any service which discovers
# programmatically something the human administrator should know will email
# root, so this should point at a real and capable human. (Examples include
# cron, when output happens, and auditd, when disk space for audit logs runs
# low.)
#
# Example usage:
# \begin{verbatim}
#     smtp::root { "the.real.admin.ctr@example.com": }
# \end{verbatim}
#

define smtp::root() {
    include smtp
# In both cases below we are editing the aliases file. If we change it, we need
# to run newaliases.
    Augeas {
        context => "/files/etc/aliases",
        notify => Exec['newaliases'],
    }
    augeas {
# If there are multiple root entries in the aliases file, delete them: we can't
# properly edit them.
        "aliases_delete_multiple_roots":
            onlyif => "match *[name='root'] size > 1",
            changes => "rm *[name='root']";
# If there is one root entry in the aliases file, make sure it has the right
# value.
        "aliases_set_root":
            onlyif => "match *[name='root'] size == 1",
            changes => "set *[name='root']/value '${name}'";
# If there is no root entry in the aliases file, add one with the right value.
        "aliases_add_root":
            onlyif => "match *[name='root'] size == 0",
            changes => [
                "ins 100000 after *[last()]",
                "set 100000/name root",
                "set 100000/value '${name}'",
            ];
    }
}
