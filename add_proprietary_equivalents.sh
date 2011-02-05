#!/bin/bash

##
# 
# This utility allows one to develop a single "living-standard" CSS file or a 
# single set of CSS files and have them automatically ported to support all major browsers.
# This file, in conjunction with the CSS Loader JavaScript and Chrome Frame utilities
# in this file, opens up the world of CSS flexible box module and transformations and more
# to cross-browser Web development.
#
# Use this utility where otherwise you would have to manually add proprietary namespace prefixes 
# to CSS rule identifiers and CSS property values.  
#
# This utility works but could be much improved and extended.
#
# This runs on the Bash shell, which also runs on Windows under Cygwin (http://cygwin.com).
#
# To run on most Bash environments, this file must be in utf-8-unix encoding.  Otherwise the error
#
#    $'\r': command not found
#
# will be encountered.
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

