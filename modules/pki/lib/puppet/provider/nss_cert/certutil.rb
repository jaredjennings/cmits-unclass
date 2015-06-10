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
require 'open3'

Puppet::Type.type(:nss_cert).provide :certutil do
    desc "Manage certificates in an NSS database using certutil from nss-utils."

    commands :certutil => "/usr/bin/certutil"

    def dbsplit
        n = @resource[:name]
        dbdir = n.split(':')[0]
        # if nickname has colon in it, don't barf
        nickname = n.split(':')[1..-1].join(':')
        if @resource[:sqlite] == :true
            dbdir = 'sql:' + dbdir
        end
        return [dbdir, nickname]
    end

    # assumption: input is short enough to fit down a pipe without blocking
    def _certutil *params, &input
        dbdir, nickname = dbsplit
        params += ['-d', dbdir, '-n', nickname]
        pwf = @resource[:pwfile]
        params += ['-f', pwf] unless pwf.nil? or pwf.empty?
        self.debug "Running #{command(:certutil).inspect} " \
                   "#{params.map {|x| x.inspect}.join(' ')}"
        stdin, stdout, stderr = Open3.popen3(command(:certutil), *params)
        yield stdin if block_given?
        stdin.close
        out = stdout.read
        stdout.close
        err = stderr.read
        stderr.close
        return out, err
    end


    def exists?
        out, err = _certutil('-L')
        if err.include? 'Could not find cert'
            self.debug "Certificate absent"
            return nil
        end
        raise Puppet::Error, err unless err.empty?
        self.debug "Certificate present"
        return :true
    end

    def destroy
        self.debug "Deleting certificate"
        out, err = _certutil('-D')
        raise Puppet::Error, err unless err.empty?
    end

    def create
        raise Puppet::Error, "Cannot install cert: no source given" unless
            @resource.parameter(:source)
        self.debug "Installing certificate " \
                   "with trustargs #{@resource[:trustargs].inspect}"
        out, err = _certutil('-A', '-t', @resource[:trustargs]) {|stdin|
            stdin.puts @resource.parameter(:source).content
        }
        raise Puppet::Error, err unless err.empty?
    end
end
