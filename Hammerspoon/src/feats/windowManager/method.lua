-- Window operation methods for Window Manager
local log = require("utils.log")

local method = {}

-- Create a scoped logger for this module
local logger = log.createLogger("WINDOW-MANAGER")

-- Maximize window using Loop
function method.maximizeWindowByLoop(win, appName)
	logger.link("Using Loop for", appName)
	hs.execute("open -g loop://direction/maximize")
end

-- Maximize window using Window/Fill menu item
function method.maximizeWindowByMenuItem(win, appName)
	local app = win:application()
	local menuItem = app:findMenuItem({ "Window", "Fill" })

	if not menuItem then
		logger.error("No Window/Fill menu for", appName)
		return false
	end

	-- Window/Fill menu exists, use select menu item to maximize the window
	local success = app:selectMenuItem({ "Window", "Fill" })
	if success then
		logger.success("Window/Fill menu selected for", appName)
		return true
	else
		logger.error("Could not select Window/Fill for", appName)
		return false
	end
end

-- Maximize window using Raycast
function method.maximizeWindowByRaycast(win, appName)
	logger.start("Using Raycast for", appName)
	hs.execute(
		"open -g raycast://extensions/raycast/window-management/maximize"
	)
end

-- Main maximizeWindow function (choose method)
function method.maximizeWindow(win, appName)
	-- Try menuItem first, then fallback to Raycast
	if method.maximizeWindowByMenuItem(win, appName) then
		return
	end

	-- Fallback to Raycast if menuItem method failed
	method.maximizeWindowByRaycast(win, appName)
	-- Alternative: You can also try Loop method
	-- method.maximizeWindowByLoop(win, appName)
end

-- Center window using Raycast
function method.centerWindowByRaycast(win, appName)
	logger.target("Using Raycast for", appName)
	hs.execute("open -g raycast://extensions/raycast/window-management/center")
end

function method.centerWindowByLoop(win, appName)
	logger.link("Using Loop for", appName)
	hs.execute("open -g loop://direction/center")
end

-- Center window using native Hammerspoon
function method.centerWindow(win, appName)
	-- method.centerWindowByRaycast(win, appName)
	method.centerWindowByLoop(win, appName)
end

return method
