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
class shell::profile_d {
# Make sure the \verb!profile.d! directory exists.
    require shell::global_init_files
    exec { "use profile.d":
        path => ['/bin', '/usr/bin'],
        command => "sed -i .before_profile_d -e '\$a\\
for i in /etc/profile.d/*.sh; do\\
\\    if [ -r \"\$i\" ]; then\\
\\        . \"\$i\"\\
\\    fi\\
done\\
' /etc/profile",
        unless => "grep -- 'if \\[ -r \"\\\$i' /etc/profile",
    }
}
