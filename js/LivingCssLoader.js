/**
 * This class loads the appropriate css file for the current user-agent.  This class works with the 'add_proprietary_equivalents.sh'
 * script in this repository, and also with the other classes and files in this directory.
 *
 *   Copyright (C) 2011  Christopher M. Balz
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */
(function callee() { 
     // This must be alone as its own statement.  It turns on ES5 Strict Mode in browsers that support it.
     "use strict";
     // Used for performance profiling and debugging.  Modify for your use.
     callee.displayName = "private-scope_for_LivingCssLoader.js";
     
     var oLivingCssLoader;

     function LivingCssLoader() {

         var nLink;

         if( self.living_css ) {
             if( self.living_css.user_agent.css.bSkipLoadingLivingCss ) {
                 
                 return;
             }
         }             

         this.S_BASE_CSS_DIR      = "css/proprietary";
         this.sUserAgentDirectory = getUserAgentDirectory.call(this);

         nLink = document.createElement("link");
         nLink["type"] = "text/css";  
         nLink["rel" ] = "stylesheet";  
         nLink["href"] = this.S_BASE_CSS_DIR + "/" + this.sUserAgentDirectory + "/index.css";                
         // Load the proprietary stylesheet (gives access to living css):
         document.getElementsByTagName("head")[0].appendChild(nLink);

         // - - - - Inner Methods:

         /**
          * Gets the user-agent.  Note that the conventional rule against using 'navigator.userAgent' here does not 
          * apply, as we are not trying to detect any one particular feature but rather the user-agent type as a whole.
          * User-agents apply proprietary css namespaces, so we need to find the actual user agent.  
          * @return string The user-agent string that corresponds to the target directory created by the build.
          */
         function getUserAgentDirectory() {

             // Note that the conventional rule against using 'navigator.userAgent' here does not apply; see method js-doc above.
             var sUA = navigator.userAgent;  

             if(/Firefox/.test( sUA )) {
                 
                 return "mozilla";
             }
             if(/Opera/.test( sUA )) {
                 
                 return "opera";
             }
             
             /*-
              * IE 8 or less will either have Chrome Frame or will be supported
              * to the extent that the w3 css identifiers are implemented in IE 10+.
              * If IE 9+ adopts the nomenclature that Opera and Safari use for 
              * css identifiers, then those can be supported by the css build.
              * See the note on IE 9 or better in the html above.
              */
             return "webkit"; 
         }
     }
     

     oLivingCssLoader = new LivingCssLoader();
 })();
