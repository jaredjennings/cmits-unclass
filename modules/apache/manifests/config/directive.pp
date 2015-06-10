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
# \subsubsection{Directives in Apache configuration}
#
# The name of resources of this type begins as discussed above, and
# ends with the name of a directive, like \verb!Options! or
# \verb!NSSUserName! or \verb!Listen!.
#
# The \verb!context_in_file! parameter is as discussed above.
#
# \verb!arguments! is an array of arguments that are written after the
# name of the directive; for example, if you wanted a directive that
# says \verb!Deny from all!, \verb!arguments! should be set to
# \verb!['from', 'all']!.

define apache::config::directive(
    $context_in_file, $arguments) {

    include apache
    $pieces = split($name, ':')
    $config_file = $pieces[0]
    $directive = $pieces[-1]
    $context_name = inline_template('<%=@pieces[1..-2].join(":")-%>')
    $context_for_d = $context_in_file ? {
        ''      => "/files/${config_file}",
        default => "/files/${config_file}/${context_in_file}",
    }
    Augeas {
        incl => $config_file,
        lens => 'Httpd.lns',
        notify => Service['httpd']
    }
    $replace_args = inline_template("
rm arg
<% @arguments.each_with_index do |a, zi| %>
set arg[<%=zi+1-%>] '<%=a-%>'
<% end %>
")
    augeas { "add ${name}":
	context => $context_for_d,
	changes => "set directive[999] '${directive}'",
	onlyif => "match directive[.='${directive}'] size == 0",
        require => $context_name ? {
            '' => [],
            default    => Apache::Config::Context[
                "${config_file}:${context_name}"],
        },
    } ->
    augeas { "correct ${name}":
	context => "${context_for_d}/directive[.='${directive}']",
	changes => $replace_args,
    }
}
