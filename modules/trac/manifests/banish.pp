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
# \subsection{Banish a user}
#
# This defined resource type removes all special access for a user from a Trac
# instance. The user will end up being able to do whatever \verb!anonymous! is
# allowed to do inside that Trac instance.
#
# The name is a directory with a Trac instance in it. Example:
# \begin{verbatim}
# trac::banish { '/var/www/tracs/admin':
#     users => ['baduser1', 'baduser2', 'baduser3'],
# }
# \end{verbatim}
#
# \dinkus

define trac::banish($users) {
    trac_permission { 'remove $users from $name':
        instance => $name,
        ensure => absent,
        subject => $users,
        action => [
            "BROWSER_VIEW", "CHANGESET_VIEW", "CONFIG_VIEW",
            "EMAIL_VIEW", "FILE_VIEW", "LOG_VIEW",
            "MILESTONE_ADMIN", "MILESTONE_CREATE",
            "MILESTONE_DELETE", "MILESTONE_MODIFY",
            "MILESTONE_VIEW", "PERMISSION_ADMIN",
            "PERMISSION_GRANT", "PERMISSION_REVOKE",
            "REPORT_ADMIN", "REPORT_CREATE", "REPORT_DELETE",
            "REPORT_MODIFY", "REPORT_SQL_VIEW", "REPORT_VIEW",
            "ROADMAP_ADMIN", "ROADMAP_VIEW", "SEARCH_VIEW",
            "TICKET_ADMIN", "TICKET_APPEND", "TICKET_CHGPROP",
            "TICKET_CREATE", "TICKET_EDIT_CC",
            "TICKET_EDIT_COMMENT", "TICKET_EDIT_DESCRIPTION",
            "TICKET_MODIFY", "TICKET_VIEW", "TIMELINE_VIEW",
            "TRAC_ADMIN", "VERSIONCONTROL_ADMIN",
            "WIKI_ADMIN", "WIKI_CREATE", "WIKI_DELETE",
            "WIKI_MODIFY", "WIKI_RENAME", "WIKI_VIEW",
        ],
    }
}

