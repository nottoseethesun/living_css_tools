/**
 *  Provides the capability to load the minimum version of Chrome Frame, or better, required to support the w3.org's
 *  Flexible Box Module.  Differs from the standard Google Chrome Frame loader in that it can load the developer or 
 *  beta channels of Chrome Frame.
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
 
(function() {
    
     function ChromeFrameVersionManager() {
        var bIsCF = /chromeframe/.test(navigator.userAgent),
            oMCFVersion, iMajorVersion;

         // When the alpha channel is at v11, there will be no need to use the Beta or Dev channels.
        this.I_MIN_CHROME_FRAME_VERSION = 11; 
        this.askForUpgrade = askForUpgrade;         

        /*-
         * Note: The developer channel of Chrome Frame does not identify itself as Chrome Frame 
         * as of this writing, February 2010.  It identifies simply as Chrome.
         */
        if(bIsCF) { 
            oMCFVersion   = navigator.userAgent.match(/chromeframe\/([^;]+);/);
            iMajorVersion = parseInt(oMCFVersion[1]);              
            // In case they have Chrome Frame, but not the minimum version:
            if(iMajorVersion < this.I_MIN_CHROME_FRAME_VERSION) {
                askForUpgrade(true);
            }
        } 

        function askForUpgrade(p_bUninstallFirst) {
            var sUninstall = "must ";

            if(p_bUninstallFirst) {
                sUninstall = " must first uninstall Google Chrome Frame (Control Panel " + 
                    "-> Add/Remove Programs).  Please do that now.  After Chrome Frame is " +
                    "uninstalled, please re-";
            }
            if(confirm("If you would like to view this site as intended on your current Web browser, Internet " + 
                       "Explorer, you " + sUninstall + "install Google Chrome Frame (developer channel). " +
                       "Please click 'Ok' to do so, and then when the Chrome Frame install is finished, " + 
                       "restart your Web browser." +
                       "\n\n " +
                       "Alternatively, please visit this site in any of the " +
                       "Safari, Firefox, or Chrome Web browsers.")) {
                // Change 'devchannel' to 'beta' as soon as the css flex-box functionality is supported.
                document.location.href = 
                    "http://www.google.com/chromeframe/eula.html?extra=devchannel";
            }
        }

    }

    self.living_css.user_agent.oChromeFrameVersionManager = new ChromeFrameVersionManager();
})();
