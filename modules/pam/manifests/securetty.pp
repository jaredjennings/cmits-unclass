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
# \subsection{securetty}
#
# Install the \verb!pam_securetty! module which prevents root from logging in
# from a tty not explicitly considered secure. See
# also~\S\ref{class_root::login}.

class pam::securetty {
    augeas { "system_auth_securetty":
        context => "/files/etc/pam.d/system-auth",
        changes => [
            "rm *[type='auth'][module='pam_securetty.so']",
# The \verb!pam::faildelay! class (\S\ref{class_pam::faildelay} inserts an
# \verb!auth! module at the beginning of the list, and so does this one.
# Without loss of generality, we will put this one second, so they don't both
# always think the file needs to be edited.
            "ins 100 before *[type='auth' and module!='pam_centrifydc.so'][2]",
            "set 100/type auth",
            "set 100/control required",
            "set 100/module pam_securetty.so",
        ]
    }
}
