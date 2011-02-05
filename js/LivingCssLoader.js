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

         function getUserAgentDirectory() {
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
