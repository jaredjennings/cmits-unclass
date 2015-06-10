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
require 'spec_helper'

describe 'swap::encrypt' do
    context 'on a Snow Leopard Mac' do
        let(:facts) {{
            :operatingsystem => 'Darwin',
            :osfamily => 'Darwin',
            :operatingsystemrelease => '10.8.0',
            :macosx_productversion_major => '10.6',
        }}

        it { should include_class('swap::encrypt::darwin') }
    end
    context 'on a Linux box' do
        let(:facts) {{
            :operatingsystem => 'RedHat',
            :osfamily => 'RedHat',
            :operatingsystemrelease => '6.4',
        }}
        it do
            expect { 
                should include_class('swap::encrypt::darwin')
            }.to raise_error(Puppet::Error, /Unimplemented on/)
        end
    end
end

