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
# \subsubsection{Contexts in Apache configuration}
#
# The Httpd Augeas lens defines directives and contexts; contexts
# correspond to \verb!<Foo>! ... \verb!</Foo>! sort of constructs in
# the configuration file. They can contain directives.
#
# The name of resources of this type begins as discussed above, and
# ends with a chosen context name, which must be an identifier (starts
# with a letter, no spaces, no special characters, just letters,
# numbers and underscores). Directive resources whose directives are
# inside this context, and context resources whose contexts are inside
# this context, will include this context name in their resource
# names, so it should be short.
#
# \verb!context_in_file! is as discussed above.
#
# \verb!type! is what kind of angle-bracket-tag sort of thing this
# context should be. Common values for \verb!type! are
# \verb!'Directory'!, \verb!'LimitExcept'!, \verb!'Location'!, and the
# like.
#
# \verb!arguments! is an array of arguments that are written inside
# the angle-brackets. For example, for a \verb!Directory! context, the
# arguments might be \verb!['/var/www']!. The result written in the
# configuration file would look like
#
# \begin{verbatim}
# <Directory /var/www>
# </Directory>
# \end{verbatim}
#
# \dinkus

define apache::config::context(
    $context_in_file, $type, $arguments) {

        include apache
        
        $pieces = split($name, ':')
        $config_file = $pieces[0]
        $parent_context_name = inline_template('<%=@pieces[1..-2].join(":")-%>')
        $this_context_name = $pieces[-1]
    augeas { "add ${name} subcontext ${type} nicknamed ${this_context_name}":
        incl => $config_file,
        lens => 'Httpd.lns',
        context => $context_in_file ? {
            ""      => "/files/${config_file}",
            default => "/files/${config_file}/${context_in_file}",
        },
        changes => inline_template("
clear <%=@type-%>[999]
<% @arguments.each_with_index do |a, zi| %>
set <%=@type-%>[last()]/arg[<%=zi+1-%>] '<%=a-%>'
<% end %>
"),
        onlyif => "match ${type}[arg='${arguments[0]}'] size == 0",
        require => $parent_context_name ? {
            '' => [],
            default => Apache::Config::Context[
                "${config_file}:${parent_context_name}"],
        },
        notify => Service['httpd'],
    }
}
