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
# \subsubsection{Insecure NSS password files}
#
# This defined resource type generates an NSS password file in the named
# database directory containing a random password. It's for use on development
# servers, which we want to be able to set up with less hands-on
# administration.
#
# This code does not deal with changing the password every year.

define pki::nss::pwfile($filename='pwfile') {
    exec { "create ${name}/${filename}":
        command => "bash -c \"\
            PW=$(head -c 24 /dev/random | base64 -); \
            for m in internal 'NSS Certificate DB' \
                    'NSS FIPS 140-2 Certificate DB'; do
                echo \\\"\\\$m:\\\$PW\\\"; done > ${name}/${filename}\"",
        path => ['/bin', '/usr/bin'],
        creates => "${name}/${filename}",
    }
}
