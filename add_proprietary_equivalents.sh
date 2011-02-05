#!/bin/bash

##
#    Build utility to allow given Web functionality specified at w3.org and whatwg.org to work where 
#    Web browsers (user agents) support the functionality with a proprietary namespace.
#
#    Copyright (C) 2011  Christopher M. Balz
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#  This utility allows one to develop a single "living-standard" (also known as "HTML5") CSS file or a 
# single set of such CSS files and have them automatically ported to support all major, 
# reasonably up-to-date Web browsers.
#
# This file, in conjunction with the CSS Loader JavaScript and Chrome Frame utilities
# in this repository, opens up the world of the CSS flexible box module, CSS transformations, and more
# to cross-browser Web development.
#
# Use this utility where otherwise you would have to manually add proprietary namespace prefixes 
# to CSS rule identifiers and CSS property values.  
#
# This utility works but could be much improved and extended.
#
# This runs on the Bash shell, which also runs on Windows under Cygwin (http://cygwin.com).
#
# To run on most Bash environments, this file must be in unix format.  Otherwise the error
#
#    $'\r': command not found
#
# will be encountered.  To move the file to unix format, use the unix command 'dos2unix', which can also 
# be found on Cygwin.
#
# Dependencies:
#
#    These are Bash shell one-liners for use with a version of 'deep.pl', available at:
#    
#        https://github.com/christopherbalz/deep.pl
#
# Author(s): Christopher M. Balz
# 

#
# We must cover two cases: One where the proprietary prefix is on the CSS property rule identifier, 
# and one where the proprietary prefix is on the CSS property value.
#

# We make a special directory for these proprietary css files, to avoid stomping on the original:

rm -Rf proprietary   # First clean up any old generated css files and directory trees.
mkdir proprietary
cp -R * proprietary
pushd proprietary
rm -Rf proprietary
rm -Rf add_proprietary_equivalents.sh

# - - - Section 1: Cover the first case, where the proprietary prefix is on the CSS property 
#                  rule identifier:
 
# Cover the case where the rule identifier is multi-part (e.g., its first part functions as 
# a namespace ('abc-') for sub-variations:
~/util/text-ops/deep_with_ee.pl replace '(^\s*|[^\w/]+)(box-|transform-|transition-|animation-|grid-|inline-)([a-z]+)(\s*:\s*)([^;]+;)' '"$1$2$3$4$5 -moz-$2$3$4$5 -webkit-$2$3$4$5 -o-$2$3$4$5"' '*.css' --literal=0 --verbose=1

# Cover the case where the proprietary prefix is on the CSS property rule identifier, 
# and the rule identifier is made up of only a single part:
~/util/text-ops/deep_with_ee.pl replace '(^\s*|[^\w/]+)(grid)(\s*:\s*)([^;]+;)' '"$1$2$3$4 -moz-$2$3$4 -webkit-$2$3$4 -o-$2$3$4"' '*.css' --literal=0 --verbose=1

# - - - Section 2: Cover the second case (as described above), where the proprietary prefix 
#                  is on the CSS property value:

function modifyCssRuleValues() {
#    ~/util/text-ops/deep_with_ee.pl replace '(^\s*|[^\w/]+)(display)(\s*:\s*)([^;]+;)' '"$1$2$3-moz-$4 $1$2$3-webkit-$4 $1$2$3-o-$4"' '*.css' --literal=0 --verbose=1
    ~/util/text-ops/deep_with_ee.pl replace '(^\s*|[^\w/]+)(display)(\s*:\s*)([^;]+;)' '"$1$2$3-'$1'-$4"' '*.css' --literal=0 --verbose=1
}

mkdir webkit
mkdir mozilla
mkdir opera

cp -R * webkit/
cp -R * mozilla/
cp -R * opera/

pushd webkit
rm -Rf webkit
rm -Rf mozilla
rm -Rf opera
rm -Rf add_proprietary_equivalents.sh
modifyCssRuleValues webkit
popd

pushd mozilla
rm -Rf mozilla
rm -Rf webkit
rm -Rf opera
rm -Rf add_proprietary_equivalents.sh
modifyCssRuleValues moz
popd

pushd opera
rm -Rf opera
rm -Rf webkit
rm -Rf mozilla
rm -Rf add_proprietary_equivalents.sh
modifyCssRuleValues o
popd

# Clean up the intermediate css file:
rm -Rf *.css

# Give read permissions to the directories and files so that the Web server can serve them:
chmod -R 755 *

# Return the user of this script to the top-level directory.
popd 

