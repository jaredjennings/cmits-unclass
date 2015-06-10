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

describe 'sudo::allow_group' do
  let(:title) { 'fungroup' }


  shared_context 'on any host' do
    it do
      should contain_file('/etc/sudoers.d/fungroup')
      should contain_augeas('remove_direct_sudoers_%fungroup')
      should contain_file('/etc/sudoers.d')
    end
  end

  context 'on a RHEL box' do
    include_context 'on any host'
    let(:facts) {{
        :osfamily => 'RedHat',
      }}
    it do
      should contain_augeas('consult_sudoers_d')
    end
  end

  context 'on a Darwin box' do
    include_context 'on any host'
    let(:facts) {{
        :osfamily => 'Darwin',
      }}
    it do
      should contain_augeas('sudoers_include_99_fungroup')
    end
  end
end
