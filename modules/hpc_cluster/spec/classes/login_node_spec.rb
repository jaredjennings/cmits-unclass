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

describe 'hpc_cluster::login_node' do
  let(:facts) { {
      :fqdn => 'bar.baz.example.com',
      :hostname => 'foo',
      :osfamily => 'RedHat',
      :operatingsystemrelease => '6.6',
    } }
  
  describe 'when using Infiniband' do
    let(:params) { {
        :internal_ipv4_first_two_octets => '10.34',
        :internal_ipv4_address => '10.34.1.2',
        :use_infiniband => 'true',
        :internal_infiniband_ipv4_first_two_octets => '10.35',
        :internal_infiniband_ipv4_address => '10.35.1.2',
        :compute_node_count => 5,
      } }

    it "should set node IB addresses in /etc/hosts on the login node" do
      should create_augeas('foo_hosts').with_changes("


rm *[canonical='head']
set 990/ipaddr    10.34.0.1
set 990/canonical head
set 990/alias     head.bar.baz.example.com
rm *[canonical='head1']
set 991/ipaddr    10.34.0.2
set 991/canonical head1
set 991/alias     head1.bar.baz.example.com
rm *[canonical='head2']
set 992/ipaddr    10.34.0.3
set 992/canonical head2
set 992/alias     head2.bar.baz.example.com
rm *[canonical='login']
rm *[canonical='bar.baz.example.com']
set 993/ipaddr    10.34.1.1
set 993/canonical bar.baz.example.com
set 993/alias[1]  login
set 993/alias[2]  login.bar.baz.example.com
rm *[canonical='login1']
rm *[canonical='bar.baz.example.com']
set 994/ipaddr    10.34.1.2
set 994/canonical bar.baz.example.com
set 994/alias[1] login1
set 994/alias[2]  login1.bar.baz.example.com
set 994/alias[3]  bar1.baz.example.com
rm *[canonical='login2']
set 995/ipaddr    10.34.1.3
set 995/canonical login2
set 995/alias[1]  login2.bar.baz.example.com
set 995/alias[2]  bar2.baz.example.com


rm *[canonical='head1-ib']
set 980/ipaddr    10.35.0.2
set 980/canonical head1-ib
set 980/alias     head1-ib.bar.baz.example.com
rm *[canonical='head2-ib']
set 981/ipaddr    10.35.0.3
set 981/canonical head2-ib
set 981/alias     head2-ib.bar.baz.example.com




rm *[canonical='n0.bar.baz.example.com']
set 200/ipaddr 10.34.50.0
set 200/canonical n0.bar.baz.example.com
set 200/alias[1]  n0

rm *[canonical='n0-ib.bar.baz.example.com']
set 400/ipaddr 10.35.50.0
set 400/canonical n0-ib.bar.baz.example.com
set 400/alias[1]  n0-ib


rm *[canonical='n1.bar.baz.example.com']
set 201/ipaddr 10.34.50.1
set 201/canonical n1.bar.baz.example.com
set 201/alias[1]  n1

rm *[canonical='n1-ib.bar.baz.example.com']
set 401/ipaddr 10.35.50.1
set 401/canonical n1-ib.bar.baz.example.com
set 401/alias[1]  n1-ib


rm *[canonical='n2.bar.baz.example.com']
set 202/ipaddr 10.34.50.2
set 202/canonical n2.bar.baz.example.com
set 202/alias[1]  n2

rm *[canonical='n2-ib.bar.baz.example.com']
set 402/ipaddr 10.35.50.2
set 402/canonical n2-ib.bar.baz.example.com
set 402/alias[1]  n2-ib


rm *[canonical='n3.bar.baz.example.com']
set 203/ipaddr 10.34.50.3
set 203/canonical n3.bar.baz.example.com
set 203/alias[1]  n3

rm *[canonical='n3-ib.bar.baz.example.com']
set 403/ipaddr 10.35.50.3
set 403/canonical n3-ib.bar.baz.example.com
set 403/alias[1]  n3-ib


rm *[canonical='n4.bar.baz.example.com']
set 204/ipaddr 10.34.50.4
set 204/canonical n4.bar.baz.example.com
set 204/alias[1]  n4

rm *[canonical='n4-ib.bar.baz.example.com']
set 404/ipaddr 10.35.50.4
set 404/canonical n4-ib.bar.baz.example.com
set 404/alias[1]  n4-ib



")
    end
  end

  describe 'when not using Infiniband' do
    let(:params) { {
        :internal_ipv4_first_two_octets => '10.34',
        :internal_ipv4_address => '10.34.1.2',
        :use_infiniband => 'false',
        # there aren't any defaults for these, so you have to set them
        :internal_infiniband_ipv4_first_two_octets => 'fnord',
        :internal_infiniband_ipv4_address => 'zart',
        :compute_node_count => 5,
      } }

    it "should not set node IB addresses in /etc/hosts on the login node" do
      should create_augeas('foo_hosts').with_changes("


rm *[canonical='head']
set 990/ipaddr    10.34.0.1
set 990/canonical head
set 990/alias     head.bar.baz.example.com
rm *[canonical='head1']
set 991/ipaddr    10.34.0.2
set 991/canonical head1
set 991/alias     head1.bar.baz.example.com
rm *[canonical='head2']
set 992/ipaddr    10.34.0.3
set 992/canonical head2
set 992/alias     head2.bar.baz.example.com
rm *[canonical='login']
rm *[canonical='bar.baz.example.com']
set 993/ipaddr    10.34.1.1
set 993/canonical bar.baz.example.com
set 993/alias[1]  login
set 993/alias[2]  login.bar.baz.example.com
rm *[canonical='login1']
rm *[canonical='bar.baz.example.com']
set 994/ipaddr    10.34.1.2
set 994/canonical bar.baz.example.com
set 994/alias[1] login1
set 994/alias[2]  login1.bar.baz.example.com
set 994/alias[3]  bar1.baz.example.com
rm *[canonical='login2']
set 995/ipaddr    10.34.1.3
set 995/canonical login2
set 995/alias[1]  login2.bar.baz.example.com
set 995/alias[2]  bar2.baz.example.com




rm *[canonical='n0.bar.baz.example.com']
set 200/ipaddr 10.34.50.0
set 200/canonical n0.bar.baz.example.com
set 200/alias[1]  n0


rm *[canonical='n1.bar.baz.example.com']
set 201/ipaddr 10.34.50.1
set 201/canonical n1.bar.baz.example.com
set 201/alias[1]  n1


rm *[canonical='n2.bar.baz.example.com']
set 202/ipaddr 10.34.50.2
set 202/canonical n2.bar.baz.example.com
set 202/alias[1]  n2


rm *[canonical='n3.bar.baz.example.com']
set 203/ipaddr 10.34.50.3
set 203/canonical n3.bar.baz.example.com
set 203/alias[1]  n3


rm *[canonical='n4.bar.baz.example.com']
set 204/ipaddr 10.34.50.4
set 204/canonical n4.bar.baz.example.com
set 204/alias[1]  n4



")
    end
  end

end



      
