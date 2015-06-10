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

describe 'cups::printer' do
  let(:title) { 'fnordprinter' }
  let(:params) { {
      :model => 'foomatic:HP-Color_LaserJet_4700-Postscript.ppd',
      :options => { 'one' => 'two', 'three' => 'four' },
      :uri => 'socket://fnordprinter:9100',
      :description => 'This is the fnord printer.',
      :location => 'Upstairs',
    }}

  context 'when ensure and enable are at their defaults' do
    expected_lpadmin_command = "lpadmin -p 'fnordprinter'\
                     -m 'foomatic:HP-Color_LaserJet_4700-Postscript.ppd'\
                     -o 'one=two' -o 'three=four'\
                     -u allow:all\
                     -v 'socket://fnordprinter:9100'\
                     -D 'This is the fnord printer.'\
                     -L 'Upstairs'"
    it do
      should contain_exec('create_printer_fnordprinter'
                          ).with_command(expected_lpadmin_command)
      should contain_exec('accept_printer_fnordprinter')
      should contain_exec('enable_printer_fnordprinter')
    end
  end
  context 'when ensure but not enable' do
    let(:params) {{
      :model => 'foomatic:HP-Color_LaserJet_4700-Postscript.ppd',
      :options => { 'one' => 'two', 'three' => 'four' },
      :uri => 'socket://fnordprinter:9100',
      :description => 'This is the fnord printer.',
      :location => 'Upstairs',
      :enable => 'false',
    }}
    it do
      should contain_exec('create_printer_fnordprinter')
      should contain_exec('reject_printer_fnordprinter')
      should contain_exec('disable_printer_fnordprinter')
    end
  end
  context 'when ensure\'s value is absent' do
    let(:params) {{
      :model => 'foomatic:HP-Color_LaserJet_4700-Postscript.ppd',
      :options => { 'one' => 'two', 'three' => 'four' },
      :uri => 'socket://fnordprinter:9100',
      :description => 'This is the fnord printer.',
      :location => 'Upstairs',
      :ensure => 'absent',
    }}
    it do
      should contain_exec('remove_printer_fnordprinter')
    end
  end
end
                                                                
