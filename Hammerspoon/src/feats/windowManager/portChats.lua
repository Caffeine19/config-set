-- Port Chat Windows Module
-- Move chat app windows to a specific display
--
-- NOTE: utils has been split into modules. Use `js` for collection helpers
-- and `find` as a standalone finder function.

local js = require("utils.js")
local filter, flatMap, forEach, map, find, foreachAsync =
	js.filter, js.flatMap, js.forEach, js.map, js.find, js.forEachAsync
local raycastNotification = require("utils.raycastNotification")
local promise = require("utils.promise")
local async, await = promise.async, promise.await
local method = require("feats.windowManager.method")

local log = require("utils.log")

local portChats = {}

-- Create a scoped logger for this module
local logger = log.createLogger("PORT-CHATS")

-- List all available screens with their details
-- Call this function to identify which screen you want to use
function portChats.listScreens()
	local screens = hs.screen.allScreens()
	logger.custom("📺", "Found", #screens, "screen(s):")
	if not screens or #screens == 0 then
		logger.error("No screens found")
		return {}
	end

	forEach(screens, function(screen, i)
		local name = screen:name()
		local id = screen:id()
		local frame = screen:frame()
		local uuid = screen:getUUID()
		local isMain = screen == hs.screen.mainScreen()

		logger.info(string.format("[%d] %s", i, name))
		logger.debug(string.format("    ID: %s", id))
		logger.debug(string.format("    UUID: %s", uuid))
		logger.debug(
			string.format(
				"    Frame: x=%d, y=%d, w=%d, h=%d",
				frame.x,
				frame.y,
				frame.w,
				frame.h
			)
		)
		logger.debug(string.format("    Main: %s", tostring(isMain)))
	end)

	return screens
end

-- Returns an `hs.screen` object when a matching screen is found, otherwise `nil`.
-- @param screenName string: exact screen name to match
function portChats.findScreenByName(screenName)
	local screens = hs.screen.allScreens()
	if not screens or #screens == 0 then
		logger.error("No screens found")
		return nil
	end

	local matchedScreen = find(screens, function(screen)
		return screenName == screen:name()
	end)

	return matchedScreen
end

-- List of chat applications to manage
portChats.appList = {
	"ChatGPT",
	"WeChat",
	"Spark",
}

-- Get all windows belonging to chat apps
function portChats.getChatWindows()
	local chatWindows = flatMap(portChats.appList, function(appName)
		local app = hs.application.get(appName)
		if not app then
			logger.error(appName, "not running")
			return {}
		end

		local windows = app:allWindows()
		local validWindows = filter(windows, function(win)
			return win:isStandard() and win:isVisible()
		end)

		return validWindows
	end)

	logger.info("Total: Found", #chatWindows, "chat window(s)")
	return chatWindows
end

-- Move chat windows to screen by name (partial match supported)
-- @param screenName: Name or partial name of the screen
function portChats.moveChatsToScreenByName_async(screenName)
	return async(function()
		local matchedScreen = portChats.findScreenByName(screenName)
		if not matchedScreen then
			logger.error("No screen found matching:", screenName)
			return false
		end

		logger.search("Found screen:", matchedScreen:name())

		local chatWindows = portChats.getChatWindows()
		if #chatWindows == 0 then
			logger.error("No chat windows found to move")
			return false
		end

		await(foreachAsync(chatWindows, function(window)
			window:focus()
			window:moveToScreen(matchedScreen, true, true, 0)
			await(promise.sleep(0.2))
			window:focus()

			method.maximize(window, window:application():name())

			await(promise.sleep(0.4))
		end))

		await(promise.sleep(0.4))
		local title = "🍀 Moved Chats to " .. matchedScreen:name()
		raycastNotification.showHUD(title)
	end)
end

-- Helper function to move chats to sidecar screen
function portChats.moveChatsToSidecar()
	return portChats.moveChatsToScreenByName_async("Sidecar Display (AirPlay)")
end

-- Helper function to move chats back to main screen
function portChats.moveChatsBack()
	return portChats.moveChatsToScreenByName_async("Built-in Retina Display")
end

return portChats
