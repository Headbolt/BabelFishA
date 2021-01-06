#!/bin/bash
#
###############################################################################################################################################
#
# ABOUT THIS PROGRAM
#
#	BabelFishA.sh
#	https://github.com/Headbolt/BabelFishA
#
#   - This script will ...
#			Detect if the Processor Architecture, and if required and supported, Install the "Rosetta 2" Translation Environment.
#
###############################################################################################################################################
#
# HISTORY
#
#	Version: 1.0 - 06/01/2021
#
#	- 06/01/202 - V1.0 - Created by Headbolt
#
###############################################################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
###############################################################################################################################################
#
Architecture=$(uname -p) # Grab the Processor Architecture
Version=$(sw_vers -productVersion) # Grab the OS Version Number
MajorVersion=$(/bin/echo $Version | cut -c -2) # Strip Out the OS Major Version Number
#
Architecture=arm
MajorVersion=11
#
# Set the name of the script for later logging
ScriptName="append prefix here as needed - Install Rosetta 2 Translation Environment"
#
###############################################################################################################################################
#
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
###############################################################################################################################################
#
# Defining Functions
#
###############################################################################################################################################
#
# Section End Function
#
SectionEnd(){
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
/bin/echo  ----------------------------------------------- # Outputting a Dotted Line for Reporting Purposes
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
}
#
###############################################################################################################################################
#
# Script End Function
#
ScriptEnd(){
#
/bin/echo Ending Script '"'$ScriptName'"'
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
/bin/echo  ----------------------------------------------- # Outputting a Dotted Line for Reporting Purposes
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
}
#
###############################################################################################################################################
#
# End Of Function Definition
#
###############################################################################################################################################
#
# Beginning Processing
#
###############################################################################################################################################
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
SectionEnd
# 
if [[ "$Architecture" == "arm" ]] # Check for "Apple Silicon" Architecture
	then
		/bin/echo "Processor is ARM Based, Rosetta is Required"
        SectionEnd
		#
		/bin/echo "Checking for Rosetta 2 LaunchDaemon"
		if [[ ! -f "/Library/Apple/System/Library/LaunchDaemons/com.apple.oahd.plist" ]] # Check Rosetta LaunchDaemon. If no LaunchDaemon is found
			then
				/bin/echo "Rosetta 2 Launch Daemon NOT Found, Proceeding with Install"
				SectionEnd
				/bin/echo "Operating System Version is $Version"
				/bin/echo # Outputting a Blank Line for Reporting Purposes
				#
				Install=$(/usr/sbin/softwareupdate --install-rosetta --agree-to-license | tee /dev/tty) # Install Rosetta 2 and Auto Accept License Agreement
				InstallUnsupported=$(echo $Install | grep "Installing Rosetta 2 on this system is not supported.") # Checking for Unsupported System
				InstallResult=$? # Capturing Install Result
				#
				if [[ $InstallResult -eq 0 ]] # Checking Install Result
					then
						if [[ "$InstallUnsupported" != "Installing Rosetta 2 on this system is not supported." ]] # Checking Reason for Failure
							then
								/bin/echo "Install of Rosetta 2 Failed !!"
								ExitCode=1
                    		else
								/bin/echo "Installing Rosetta 2 on this system is not supported."
								ExitCode=2
						fi
					else
						/bin/echo "Install of Rosetta 2 finished successfully."
						ExitCode=0
				fi
			else
				/bin/echo "Rosetta 2 Launch Daemon Found, No further Action required"
				ExitCode=0
		fi
	else
		/bin/echo "Processor is listed as $Architecture, Rosetta is NOT Required"
		ExitCode=0
fi
#
SectionEnd
ScriptEnd
exit $ExitCode
