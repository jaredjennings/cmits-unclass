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
# \subsection{Custom YUM repository on Vagrant machines}
#
# On a proper network we may have a Red Hat Satellite server, but on a Vagrant
# host we may not have any networking, or may not be on the same network as
# such a server. Installation of most custom packages should be avoided under
# Vagrant, but some cannot be avoided. This class allows for custom packages
# distributed with the Vagrant machine to be made available to the virtual
# machine.
#
# Virtual machines set up with Vagrant are not secure in a networking sense:
# they have a fixed default root password, a default user with a fixed default
# password having sudo access, fixed insecure ssh keys, etc. In line with these
# decisions, we won't perform GPG signature checks on the RPMs in the custom
# repository, because the provenance of these packages is already exactly as
# secure as the provenance of the Puppet policy applied at install time: any
# attacker who could pervert a custom package could just change the Puppet
# policy. And the virtual machine built from these things is ephemeral and
# untrusted anyway.

class yum::vagrant() {
    yumrepo { "vagrant":
        name => "vagrant",
        baseurl => "file:///vagrant/custom-packages",
        enabled => 1,
        gpgcheck => 0,
    }
}
