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
require 'tmpdir'
require 'spec_helper'

describe 'sudo_user_1', :with_tmpdir => true do
  let(:sudoers_d) { '/etc/sudoers.d' }

  shared_examples_for "proper sudoers.d file creation" do
    it "should define the EDITORS Cmnd_Alias" do
      should create_file("#{sudoers_d}/30EDITORS").with_content("
Cmnd_Alias EDITORS = \\
    /usr/bin/vim, /usr/bin/emacs
")
      should create_datacat_fragment('command_alias EDITORS'
                                     ).with_data({'noexec' => ['EDITORS']})
    end

    it "should define the SINGLE_MEMBER_ARRAY Cmnd_Alias" do
      should create_file("#{sudoers_d}/30SINGLE_MEMBER_ARRAY").with_content("
Cmnd_Alias SINGLE_MEMBER_ARRAY = \\
    /bin/true
")
      should create_datacat_fragment('command_alias SINGLE_MEMBER_ARRAY'
                                     ).with_data({'setenv_exec' => ['SINGLE_MEMBER_ARRAY']})
    end

    it "should define the SINGLE_ITEM Cmnd_Alias" do
      should create_file("#{sudoers_d}/30SINGLE_ITEM").with_content("
Cmnd_Alias SINGLE_ITEM = \\
    /bin/false
")
      should create_datacat_fragment('command_alias SINGLE_ITEM'
                                     ).with_data({'noexec' => ['SINGLE_ITEM']})
    end

    it "should define the BAD_STUFF Cmnd_Alias" do
      should create_file("#{sudoers_d}/30BAD_STUFF").with_content("
Cmnd_Alias BAD_STUFF = \\
    /sbin/fdisk
")
      should create_datacat_fragment('command_alias BAD_STUFF'
                                     ).with_data({'DISALLOW_noexec' => ['BAD_STUFF']})
    end

    it "should bind the parts into a whole" do
      should create_file('sudoers.d/90auditable_whole').with_path("#{sudoers_d}/90auditable_whole")
      should create_datacat('sudoers.d/90auditable_whole').with_template('sudo/auditable/whole.erb')
    end

    it "should allow the luckygroup to run things" do
      should create_file("#{sudoers_d}/99_luckygroup").with_content(
"%luckygroup ALL=(ALL) \\
    NOPASSWD:NOEXEC:        AUDITABLE_NOEXEC, \\
    NOPASSWD:EXEC:          AUDITABLE_EXEC,   \\
    NOPASSWD:SETENV:NOEXEC: AUDITABLE_SETENV_NOEXEC, \\
    NOPASSWD:SETENV:EXEC:   AUDITABLE_SETENV_EXEC
")
    end
  end

  describe "on a Mac" do
    let(:facts) {{ :osfamily => 'Darwin' }}
    include_examples "proper sudoers.d file creation"
    it "should add include statements to the sudoers file" do
      should create_augeas('sudoers_include_90auditable_whole')
    end
  end

  describe "on a RHEL box" do
    let(:facts) {{ :osfamily => 'RedHat' }}
    include_examples "proper sudoers.d file creation"
  end

  
  # I guess we don't get to test the actual contents of the files
  # here: if we wanted to, we would have to write an acceptance spec
  # using Beaker, which would spin up a VM or container, run the
  # catalog inside it, and let us make assertions about the resultant
  # system state.

end
