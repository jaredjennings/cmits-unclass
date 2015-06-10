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
# \subsubsection{Under RHEL6}
#
# In RHEL6, banner functionality is inside gdm.

class dod_login_warnings::gdm::rhel6 {
    $agsg = '/apps/gdm/simple-greeter'
    gconf { "$agsg/banner_message_enable":
        config_source => '/var/lib/gdm/.gconf',
        type => bool,
        value => true,
    }
    gconf { "$agsg/banner_message_text":
        config_source => '/var/lib/gdm/.gconf',
        type => string,
        value => template('dod_login_warnings/paragraphs'),
    }

# All those settings probably created root-owned, solely-root-readable files in
# gdm's home directory. We need to let the gdm user read those files.
    file { '/var/lib/gdm/.gconf':
        owner => gdm, group => gdm,
        recurse => true, recurselimit => 5,
    }
}
