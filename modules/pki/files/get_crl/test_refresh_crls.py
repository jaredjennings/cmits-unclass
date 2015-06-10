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
from refresh_crls import CACert, CRL, openssl
from refresh_crls import CACertExpired
import unittest
from tempfile import mkdtemp
from shutil import rmtree
import os
import time

class HasDir(unittest.TestCase):
    def setUp(self):
        self.dir = mkdtemp(prefix='fetchcrltest')
        self.oldcwd = os.getcwd()
        os.chdir(self.dir)
    def tearDown(self):
        os.chdir(self.oldcwd)
        #rmtree(self.dir)
        pass

class CACertBase(HasDir):
    def makeCert(self, dnElements=('C=US', 'O=Test', 'OU=Test',
            'CN=Flarble'), additionalConfig='',
            additionalSwitches=''):

        cnf = file('cnf', 'w')
        print >> cnf, """
[ req ]
default_bits		= 2048
default_keyfile 	= privkey.pem
distinguished_name	= req_distinguished_name
x509_extensions	= v3_ca	# The extentions to add to the self signed cert
input_password = secret
output_password = secret
days=-1
prompt = no
%s
[ req_distinguished_name ]
%s
[ v3_ca ]
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always,issuer:always
basicConstraints = CA:true
""" % (additionalConfig, '\n'.join(dnElements))
        cnf.close()
        cert = '\n'.join(openssl('req', '-new', '-x509', '-config', 'cnf',
            *additionalSwitches.split()))
        cert_filename = 'cert'
        cfile = file(cert_filename, 'w')
        print >> cfile, cert
        cfile.close()
        time.sleep(1) # make sure we're after the not-valid-before time
        return cert_filename

class TestCACert(CACertBase):
    def testCN(self):
        c = CACert(self.makeCert())
        self.assertEqual(c.cn, 'Flarble')

    def testValid(self):
        c = CACert(self.makeCert())
        self.assert_(c.isValid())

    def testInvalid(self):
        c = CACert(self.makeCert(additionalSwitches='-days -1'))
        self.assert_(not c.isValid())
        crl = CRL(c, self.dir, None)
        self.assertRaises(CACertExpired, crl.fetch)

    def testDoDCRLSources(self):
        # see req(1), 'DISTINGUISHED NAME ... FORMAT' section, about the
        # 1.OU, 2.OU
        c = CACert(self.makeCert(['C=US', 'O=U.S. Government',
            '1.OU=DoD', '2.OU=PKI', 'CN=Unit Test CA']))
        self.assert_(len(c.getSources()) > 0)

if __name__ == '__main__':
    unittest.main()
