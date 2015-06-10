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
# \subsection{STIG-required mail configuration}
#
class smtp::stig {
    include smtp
# \implements{unixsrg}{GEN004640} Disable the decode alias.
#
# Even though the comment that comes above this in the stock configuration
# (``trap decode to catch security attacks'') indicates that it may be positive
# to leave it uncommented, the STIG specifies that it must be deleted or
# commented out, and does not discuss further.
    augeas { "remove_decode_alias":
        context => "/files/etc/aliases",
        changes => [
            "rm *[name='decode']",
# Go ahead and remove that comment too.
            "rm #comment[. =~ regexp('trap decode.*')]",
        ],
        notify => Exec['newaliases'],
    }

# \implements{unixsrg}{GEN004360,GEN004370,GEN004380} Control ownership and
# permissions of the \verb!aliases! file.
    file { "/etc/aliases":
        owner => root, group => 0, mode => 0644,
    }
# \implements{unixsrg}{GEN004390} Remove extended ACLs on the \verb!aliases!
# file.
    no_ext_acl { "/etc/aliases": }

    case $::osfamily {
        'RedHat': {
            case $::operatingsystemrelease {
                /^6\..*/: {
# \implements{unixsrg}{GEN004580} Configure the mail server to ignore
# \verb!.forward! files. (See~also~\S\ref{define_home::quick}.)
#
# The \verb!forward_path! should really be empty, but the Augeas lens for the
# Postfix configuration doesn't support empty values, and it looks difficult to
# make it do so, and it's difficult to modify the configuration by other means.
# This will do.
                    include smtp::postfix
                    augeas { "ignore_forward_files":
                        context => "/files/etc/postfix/main.cf",
                        notify => Service['postfix'],
                        changes => "set forward_path /dev/null",
                    }
                }
                /^5\..*/: {
                    include smtp::sendmail
                    $smmc = '/etc/mail/sendmail.mc'
                    $def  = "'define(`confFORWARD_PATH'\\'', `'\\'')dnl'"
                    exec { 'ignore_forward_files':
                        command => "sed -i -e '\$a '${def}  ${smmc}",
                        unless =>  "grep      '^'${def}'\$' ${smmc}",
                        notify =>  Exec['update_sendmail_config'],
                    }
                }
                default: { unimplemented() }
            }
        }
# I don't think Mac OS X runs an SMTP server.
        'Darwin': {}
        default: { unimplemented() }
    }
}
