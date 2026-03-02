local js = require("utils.js")
local diff, map = js.diff, js.map

local log = require("utils.log")

local logger = log.createLogger("SCREEN-EVENT")

local screenEvent = {}

local connectedScreens = hs.screen.allScreens()

local function handleScreenChange()
	local currentScreens = hs.screen.allScreens()
	if not currentScreens or not connectedScreens then
		logger.error("Failed to get current screens")
		return "nothing", {}
	end

	local diffCount = #currentScreens - #connectedScreens
	if diffCount == 0 then
		-- logger.info(
		-- 	"Screen configuration changed, but no screens were added or removed."
		-- )

		connectedScreens = currentScreens
		return "nothing", {}
	end

	if diffCount > 0 then
		local diffScreens = diff(currentScreens, connectedScreens, function(s)
			return s:id()
		end)

		connectedScreens = currentScreens
		return "connected", diffScreens
	end

	local diffScreens = diff(connectedScreens, currentScreens, function(s)
		return s:id()
	end)

	connectedScreens = currentScreens
	return "disconnected", diffScreens
end

local screenWatcher
function screenEvent.onScreenChanged(func)
	logger.debug("Setting up screen change watcher...")
	screenWatcher = hs.screen.watcher.new(function()
		-- logger.debug("Screen change detected, determining type of change...")
		local type, diffScreens = handleScreenChange()
		if type == "nothing" then
			return
		end

		logger.debug(
			"Screen change type:",
			type,
			"| Diff screens:",
			diffScreens
		)

		func(type, diffScreens)
	end)

	screenWatcher:start()
end

return screenEvent
