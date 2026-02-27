-- Window operation methods for Window Manager
local log = require("utils.log")

local method = {}

-- Create a scoped logger for this module
local logger = log.createLogger("WINDOW-MANAGER")

-- ── Loop methods ────────────────────────────────────────────────────────────
method.loop = {}

function method.loop.maximize(_, appName)
	logger.link("Using Loop for", appName)
	hs.execute("open -g loop://direction/maximize")
end

function method.loop.center(_, appName)
	logger.link("Using Loop for", appName)
	hs.execute("open -g loop://direction/center")
end

-- ── Raycast methods ──────────────────────────────────────────────────────────
method.raycast = {}

function method.raycast.maximize(_, appName)
	logger.start("Using Raycast for", appName)
	hs.execute(
		"open -g raycast://extensions/raycast/window-management/maximize"
	)
end

function method.raycast.center(_, appName)
	logger.target("Using Raycast for", appName)
	hs.execute("open -g raycast://extensions/raycast/window-management/center")
end

-- ── Menu item methods ────────────────────────────────────────────────────────
method.menuitem = {}

function method.menuitem.maximize(win, appName)
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

-- ── Top-level helpers (choose method) ───────────────────────────────────────

-- Maximize: try menuitem first, fallback to Raycast
function method.maximize(win, appName)
	if method.menuitem.maximize(win, appName) then
		return
	end

	-- Fallback to Raycast if menuitem method failed
	method.raycast.maximize(win, appName)
	-- Alternative: method.loop.maximize(win, appName)
end

-- Center: use Loop by default
function method.center(win, appName)
	method.loop.center(win, appName)
	-- Alternative: method.raycast.center(win, appName)
end

return method
