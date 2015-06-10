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
# \subsection{Pylons In SEEK EAGLE (PISE)}
#
# RHEL 6 includes Pylons 1.0, and the many other Python packages which it
# requires and uses. It appears that this forms a good foundation for building
# new web applications in Python, where `good' means these things:
#
# \begin{itemize}
# \item Supported with security updates
# \item Easy to install on RHEL 6
# \item Already works for lots of people in the industry
# \item Good documentation is available
# \item Training may be available
# \item Short write--manual test--modify cycle
# \item It's easy to write and run unit and functional tests
# \item Debuggable (\emph{i.e.}, runnable using a debugger)
# \item Deployment is well-defined
# \item Authentication methods can be changed
# \end{itemize}
#
# ``Pylons'' is mostly a collective term for many pieces which are bound
# together into a platform on which to write a web application. PISE denotes
# all the conventions, common pieces of configuration, and procedures involved
# in making and deploying Pylons applications under this \CMITSPolicy .
#
# Colophon: a \emph{pylon} is the entrance to an Egyptian temple. \emph{Pis\'e
# de terre} (pee-ZAY deuh TAIR) is a technique of building walls or large
# bricks using rammed earth.
