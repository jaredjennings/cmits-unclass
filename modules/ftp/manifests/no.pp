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
# \subsection{Disable FTP}

class ftp::no {

# \implements{unixsrg}{GEN004800,GEN004820,GEN004840}%
# Remove FTP server software wherever possible.
    package { "vsftpd": ensure => absent }

# Remove the ftp user so pwck will be happy. Since it's a system uid, chances
# that it will be reused for a different user are lower; so if ftp happened to
# own any files they will likely remain secure.
    user { "ftp": ensure => absent }

}

# \notapplicable{unixsrg}{GEN004880,GEN004900,GEN004920,GEN004930,GEN004940,GEN004950}%
# Where FTP is disabled, the \verb!ftpusers! file likely does not exist, but
# that isn't a problem.
#
# \notapplicable{rhel5stig}{GEN004980}%
# Where FTP is disabled, the FTP daemon cannot be ``configured for logging or
# verbose mode.''
#
# \notapplicable{unixsrg}{GEN005000,GEN005020,GEN005040}%
# Since we have no FTP servers, we do no anonymous FTP.

