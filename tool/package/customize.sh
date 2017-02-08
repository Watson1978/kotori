#!/bin/bash

VOLUME_NAME=$1

# http://stackoverflow.com/questions/96882/how-do-i-create-a-nice-looking-dmg-for-mac-os-x-using-command-line-tools?answertab=votes#tab-top
osascript<<END
	tell application "Finder"
		tell disk "${VOLUME_NAME}"
			open
			tell container window
				set current view to icon view
				set toolbar visible to false
				set statusbar visible to false
				set the bounds to {400, 100, 1000, 600}
				set position of item "kotori" to {200, 200}
				set position of item "Applications" to {375, 200}
			end tell

			set theViewOptions to the icon view options of container window
			tell theViewOptions
				set arrangement to not arranged
				set icon size to 72
				set background color to {7168, 39680, 37376}
			end tell

			update without registering applications
		end tell
	end tell
END
