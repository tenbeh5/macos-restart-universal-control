-- Retry wrapper for flaky UI interactions
on retrying(actionHandler)
	set maxTries to 3
	repeat with i from 1 to maxTries
		try
			run script actionHandler
			exit repeat
		on error errMsg
			if i = maxTries then
				display dialog "Error after " & maxTries & " tries: " & errMsg
				return false
			end if
			delay 0.5
		end try
	end repeat
	return true
end retrying

-- Function to check assistive access
on isAssistiveAccessEnabled()
	try
		tell application "System Events" to count processes
		return true
	on error
		return false
	end try
end isAssistiveAccessEnabled

-- Main script
if not isAssistiveAccessEnabled() then
	display dialog "This script requires assistive access. Please enable it in System Settings > Privacy & Security > Accessibility." buttons {"OK"} default button "OK"
	tell application "System Settings" to activate
	return
end if

tell application "System Settings" to activate
delay 0.5

-- Retryable UI block
retrying("
	tell application \"System Events\"
		tell process \"System Settings\"
			-- Open Displays settings
			try
				click menu item \"Displays\" of menu \"View\" of menu bar 1
			on error
				click button \"Displays\" of scroll area 1 of window 1
			end try
			
			delay 1
			
			-- Click the Advanced button
			try
				click button 1 of scroll area 2 of group 1 of group 2 of splitter group 1 of group 1 of window 1
			on error
				display dialog \"Could not find the Advanced button.\"
				return
			end try
			
			delay 0.5
			
			-- Toggle pointer/keyboard sharing
			try
				set pointerSetting to checkbox \"Allow your pointer and keyboard to move between any nearby Mac or iPad\" of group 2 of scroll area 1 of group 1 of sheet 1 of window 1
				if (value of pointerSetting as boolean) is true then
					click pointerSetting
					delay 0.2
					click pointerSetting
				else
					click pointerSetting
					delay 0.2
					click pointerSetting
				end if
			on error
				display dialog \"Could not find the pointer and keyboard setting.\"
				return
			end try
		end tell
	end tell
")

delay 0.2
quit application "System Settings"
