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
# \section{Common packages}
#
# You only get to declare a package once in the whole manifest. But
# some packages are depended on by many modules. According to a
# googling done in Fall 2013, options for this are:
#
# \begin{enumerate}
# \item Surround every package resource with
# \verb+if # !defined(Package[bla]) {...}+.
# \item Write every possible package resource as a virtual resource in
# one place; realize packages where they are needed.
# \item Wherever class A and class B both want to install package X,
# write a new class C that installs package X, and make A and B depend
# on C.
# \end{enumerate}
#
# Here we implement the third approach.
