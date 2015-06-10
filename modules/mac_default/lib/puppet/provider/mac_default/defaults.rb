# CMITS - Configuration Management for Information Technology Systems
# Based on <https://github.com/afseo/cmits>.
# Copyright 2015 Jared Jennings <mailto:jjennings@fastmail.fm>.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
require 'puppet'

Puppet::Type.type(:mac_default).provide :defaults do
    desc "Manage automounts on a Mac using the defaults command."

    commands :defaults => "/usr/bin/defaults"
    confine :operatingsystem => :darwin
    defaultfor :operatingsystem => :darwin

    def parse_defaults_output_string x; x; end
    def parse_defaults_output_integer x; x; end
    def parse_defaults_output_float x; x; end
    def parse_defaults_output_boolean x
        # it will be 0 or 1
        i = x.to_i
        i == 1 ? :true : :false
    end
    def parse_defaults_output_date x
        # "2013-02-23 06:00:00 -0600"
        x.split(' ')[0]
    end
    def parse_defaults_output_array x
        # arrays seem to always contain strings
        result = []
        lines = x.split("\n")
        lines.each do |line|
            case line.strip
            when "(", ")"
                # first and last lines are parentheses. do nothing
            when /"(.*)",?$/
                # quotes are used when values contain, e.g., commas
                # apparently defaults(1) cannot parse values containing double
                # quotes. whew, dodged that one
                result << $1
            when /(.*),?$/
                result << $1
            end
        end
        result
    end
    def parse_defaults_output_dictionary x
        # likewise, dicts seem to always contain strings
        result = {}
        lines = x.split("\n")
        lines.each do |line|
            case line.strip
            when "{", "}"
                # first and last lines are curly braces. do nothing
            when /^"([^"]*)" = "([^"]*)";?$/
                # quotes are used when values contain equal signs, etc.
                # apparently defaults(1) cannot parse values containing double
                # quotes, so we needn't worry about escaped quotes
                result[$1] = $2
            when /^"([^"]*)" = ([^;]+);?$/, /^([^= ]+) = "([^"]*)";?$/
                # only one of the values was quoted
                result[$1] = $2
            when /^([^=]+) = ([^;]+);?$/
                # no values quoted
                result[$1] = $2
            end
        end
        # If the value is a Hash, it was munged into an array; so to make our
        # understanding of defaults' output comparable, we munge it into an
        # array as well.
        result.to_a
    end

    def parse_type output
        case output
        when /^Type is ([a-z]+)$/
            $1
        else
            fail "Did not understand output of defaults command: #{output.inspect}"
        end
    end

    def exists?
        type_out = execute([:defaults, 'read-type', @resource[:domain],
                            @resource[:key]], :combine => false).chomp
        return false if type_out == ""
        type = parse_type(type_out)
        begin
            parser = method('parse_defaults_output_' + type)
        rescue
            fail "Don't know how to parse defaults values of type #{type}"
        end
        value_out = execute([:defaults, 'read', @resource[:domain],
                            @resource[:key]], :combine => false).chomp
        value = parser.call(value_out)
        debug "#{@resource[:value].inspect} == #{value.inspect}?"
        value == @resource[:value]
    end

    def create
        # Since our type values happen to have the same names as switches to
        # the defaults command...
        type_switch = '-' + @resource[:type].to_s
        if @resource[:source]
            content = @resource.parameter(:source).content
        else
            content = @resource[:value]
        end
        execute([:defaults, 'write', @resource[:domain], @resource[:key],
                type_switch, content])
    end

    def destroy
        execute([:defaults, 'delete', @resource[:domain], @resource[:key]])
    end
end
