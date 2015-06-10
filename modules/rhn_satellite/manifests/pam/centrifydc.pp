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
# \subsubsection{Use Centrify DirectControl}

class rhn_satellite::pam::centrifydc {
    augeas { "rhn_satellite_pam_d":
        require => Package['CentrifyDC'],
        context => "/files/etc/pam.d/rhn-satellite",
        changes => [
            "rm *",
            "set 1/type     auth",
            "set 1/control  required",
            "set 1/module   pam_env.so",
            "set 2/type     auth",
            "set 2/control  sufficient",
            "set 2/module   pam_centrifydc.so",
            "set 3/type     auth",
            "set 3/control  requisite",
            "set 3/module   pam_centrifydc.so",
            "set 3/argument deny",
            "set 4/type     account",
            "set 4/control  sufficient",
            "set 4/module   pam_centrifydc.so",
            "set 5/type     account",
            "set 5/control  required",
            "set 5/module   pam_centrifydc.so",
        ],
    }
}
