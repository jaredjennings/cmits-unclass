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
# \section{SMTP}
#
# Configure SMTP properly. This whole module is presently RHEL6-specific and
# Postfix-specific.
#
# \bydefault{RHEL5, RHEL6}{unixsrg}{GEN004400}%
# \bydefault{RHEL5, RHEL6}{unixsrg}{GEN004410}%
# \bydefault{RHEL5, RHEL6}{unixsrg}{GEN004420}%
# \bydefault{RHEL5, RHEL6}{unixsrg}{GEN004430}%
# The default RHEL aliases file does not contain any entries which execute
# programs.
#
# \notapplicable{unixsrg}{GEN004440}%
# We use postfix, not sendmail.
#
# \bydefault{RHEL6}{unixsrg}{GEN004460}%
# RHEL6 logs all mail server messages by default.
#
# \bydefault{RHEL6}{unixsrg}{GEN004540}%
# Postfix does not recognize the SMTP \verb!HELP! command.
#
# \bydefault{RHEL6}{unixsrg}{GEN004560}%
# Postfix under default RHEL6 settings does not divulge its version in its
# greeting.
#
# \bydefault{RHEL6}{unixsrg}{GEN004600}%
# Red Hat provides up-to-date SMTP servers.
#
# \notapplicable{unixsrg}{GEN004620}%
# We use postfix, not sendmail.
#
# \bydefault{RHEL6}{unixsrg}{GEN004660}%
# Postfix does not recognize the SMTP \verb!EXPN! command.
#
# \bydefault{RHEL6}{unixsrg}{GEN004680}%
# Postfix does not provide any information in response to an SMTP \verb!VRFY!
# request.
#
# \bydefault{RHEL6}{unixsrg}{GEN004700}%
# Postfix does not recognize the SMTP \verb!WIZ! command.
#
# \bydefault{RHEL6}{unixsrg}{GEN004710}%
# Postfix under default RHEL6 settings accepts email only from the local
# system. This policy does not change this default.

class smtp {
# When the aliases file has changed, run newaliases. Our edits using Augeas
# will notify this exec resource.
    exec { "newaliases":
        command => "/usr/bin/newaliases",
        refreshonly => true,
    }

# \implements{unixsrg}{GEN004480}%
# Control ownership of the SMTP log.  (Permissions and ACLs are controlled
# by~\S\ref{class_log::stig}.)
    file { "/var/log/maillog": owner => root }
}

# \subsection{Admin guidance regarding SMTP}
#
# \doneby{admins}{unixsrg}{GEN004400,GEN004410,GEN004420,GEN004430}%
# Do not add any entries to the aliases file which execute programs.
#
