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
all: sudo-boldface.pdf

clean:
	rm -f deps sudo-boldface.{aux,log,pdf} svnversion.txt

%.pdf: %.tex
	pdflatex $^
	pdflatex $^

sudo-boldface.pdf: sudo-boldface.tex svnversion.txt


include deps

deps:
	find . -name .svn -prune -o -type f \
		\! -name '*~' \! -name '*.pdf' \! -name deps \
		\! -name svnversion.txt \! -name '.nfs*' \
		-printf "svnversion.txt: %p\\ndeps: %p\\n" > $@

svnversion.txt:
	svnversion > $@

.PHONY: all clean