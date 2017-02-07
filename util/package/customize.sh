#!/bin/bash

VOLUME_NAME=$1

# http://stackoverflow.com/questions/96882/how-do-i-create-a-nice-looking-dmg-for-mac-os-x-using-command-line-tools?answertab=votes#tab-top
osascript<<END
	tell application "Finder"
		tell disk "${VOLUME_NAME}"
			open
			set toolbar visible of container window to false
			set statusbar visible of container window to false
			set the bounds of container window to {400, 100, 1000, 600}
			set theViewOptions to the icon view options of container window
			set arrangement of theViewOptions to not arranged
			set icon size of theViewOptions to 72

			set current view of container window to icon view
			set background color of theViewOptions to {7168, 39680, 37376}

			set position of item "kotori" of container window to {200, 200}
			set position of item "Applications" of container window to {375, 200}
			update without registering applications
		end tell
	end tell
END
