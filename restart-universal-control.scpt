tell application "System Settings"
	activate
end tell

-- Wait for the System Settings window to open
delay 1

tell application "System Events"
	tell process "System Settings"
		-- Open "Displays" settings
		try
			click menu item "Displays" of menu "View" of menu bar 1
		on error
			-- If the menu approach fails, try navigating through the sidebar.
			click button "Displays" of scroll area 1 of window 1
		end try
		
		-- Wait for the Displays window to load
		delay 1
		
		
		
		-- Click the "Advanced…" button, if available
		try
			-- click button "Advanced…" of window 1
			click button 1 of scroll area 2 of group 1 of group 2 of splitter group 1 of group 1 of window 1
		on error
			display dialog "Could not find the Advanced button."
			return
		end try
		
		-- Wait for the Advanced settings to appear
		delay 1
		
		-- Toggle the checkbox for "Allow your pointer and keyboard to move between any nearby Mac or iPad"
		try
			set pointerSetting to checkbox "Allow your pointer and keyboard to move between any nearby Mac or iPad" of group 2 of scroll area 1 of group 1 of sheet 1 of window 1
			if (value of pointerSetting as boolean) is true then
				click pointerSetting -- Turn it off
				delay 1
				click pointerSetting -- Turn it back on
			else
				click pointerSetting -- Turn it on
				delay 1
				click pointerSetting -- Turn it off and then back on
				click pointerSetting
			end if
		on error
			display dialog "Could not find the pointer and keyboard setting."
			return
		end try
	end tell
	
	key code 53
end tell

delay 1

quit application "System Settings"