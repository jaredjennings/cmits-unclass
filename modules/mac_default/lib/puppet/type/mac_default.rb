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

Puppet::Type.newtype(:mac_default) do
    @doc = <<-EOT
        Manage 'defaults' on Macs - that is, settings in property list files.

        This is done by several other folk using Puppet defined resource types;
        we do it here using a custom type so to be able easily to provide
        values containing quotes and other shell-special characters.

        Example:
        
            mac_default { 'meaningless_name':
                domain => '/path/to/settings.plist',
                key => 'key_name',
                ensure => present,
                type => string,
                value => 'value',
            }
    
        (If you specify '/path/to/settings.plist:key_name' as the title, you
        don't have to give the domain or key arguments.)
    EOT

    ensurable do
        defaultvalues
        defaultto :present
    end

    newparam(:domain) do
        desc <<-EOT
        The absolute path of a property list file, omitting the '.plist'
        extension. If you fail to omit the extension it will be omitted for
        you.

        EOT
        isnamevar
        isrequired
        newvalues /^\/[^:]*$/
        munge do |value|
            if value =~ /\.plist$/
                value = value[0..-('.plist'.length+1)]
            end
            value
        end
    end

    newparam(:key) do
        desc "The preference key within the file."
        isnamevar
        isrequired
        newvalues /^[^:].*/
    end

    def self.title_patterns
        [
            [/^([^:]+):(.+)$/, [
                [ :domain, lambda {|x| x} ],
                [ :key,    lambda {|x| x} ]]],
            [/^.*$/, []]]
    end

    newparam(:type) do
        desc "The type of the value. Defaults to string."
        newvalues :string, :int, :float, :bool, :date, :array, :dict
        defaultto :string
    end

    newparam(:value) do
        desc "The intended value for the given key in the given property list file."
        munge do |v|
            if v.is_a? Hash
                v.to_a
            else
                v
            end
        end
    end

    newparam(:source) do
        desc <<-EOT
        Source of the value. Like the source parameter of the file resoure
        type, this can take a puppet:/// URL.

        If this parameter is given, it supersedes the value parameter.
        EOT

        # this parameter's code comes from puppet's type/file/source.rb
        validate do |sources|
            sources.each do |source|
                begin
                    uri = URI.parse(URI.escape(source))
                rescue => detail
                    self.fail "Could not understand source #{source}: #{detail}"
                end
                self.fail "Cannot use URLs of type '#{uri.scheme}' as source for fileserving" unless uri.scheme.nil? or %w{file puppet}.include?(uri.scheme)
            end
        end

        munge do |sources|
            sources = [sources] unless sources.is_a?(Array)
            sources
        end

        # Look up (if necessary) and return remote content.
        def content
          return @content if @content
          raise Puppet::DevError, "No source for content was stored with the metadata" unless metadata.source

          unless tmp = Puppet::FileServing::Content.indirection.find(metadata.source)
            fail "Could not find any content at %s" % metadata.source
          end
          @content = tmp.content
        end

        # Provide, and retrieve if necessary, the metadata for this file.  Fail
        # if we can't find data about this host, and fail if there are any
        # problems in our query.
        def metadata
          return @metadata if @metadata
          return nil unless value
          value.each do |source|
            begin
              if data = Puppet::FileServing::Metadata.indirection.find(source)
                @metadata = data
                @metadata.source = source
                break
              end
            rescue => detail
              fail detail, "Could not retrieve file metadata for #{source}: #{detail}"
            end
          end
          fail "Could not retrieve information from environment #{Puppet[:environment]} source(s) #{value.join(", ")}" unless @metadata
          @metadata
        end

    end
end
