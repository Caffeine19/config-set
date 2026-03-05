-- Kerio VPN: Automates connecting to VPN via Ice menu bar search
local promise = require("Utils.promise")
local raycastNotification = require("Utils.raycastNotification")
local log = require("Utils.log")

local async, await = promise.async, promise.await

local logger = log.createLogger("KERIO")

local kerio = {}

--- Connect to Kerio VPN server via Ice menu bar search
function kerio.connect_async()
	return async(function()
		logger.start("Connecting to Kerio VPN...")

		-- Step 1: Kill SecoClient to avoid VPN conflict
		local secoApp = hs.application.get("SecoClient")
		local secoWasRunning = secoApp ~= nil
		if secoWasRunning then
			logger.info("Killing SecoClient...")
			secoApp:kill()
			await(promise.sleep(1))
		end

		-- Step 2: Open Ice menu bar search modal (Cmd+Ctrl+I)
		logger.search("Opening Ice menu bar search...")
		hs.eventtap.keyStroke({ "cmd", "ctrl" }, "i")
		await(promise.sleep(0.5))

		-- Step 3: Type "kvpn" to search for Kerio VPN menu item, then confirm
		logger.type("Searching for Kerio VPN menu item...")
		hs.eventtap.keyStrokes("kvpn")
		await(promise.sleep(0.5))
		hs.eventtap.keyStroke({}, "return")
		await(promise.sleep(0.5))

		-- Step 4: Move to target server and confirm
		logger.search("Selecting target server...")
		hs.eventtap.keyStroke({}, "down")
		await(promise.sleep(0.3))
		hs.eventtap.keyStroke({}, "return")

		-- Step 5: Reopen SecoClient if it was running
		if secoWasRunning then
			await(promise.sleep(3))
			logger.launch("Reopening SecoClient...")
			hs.application.open("SecoClient")
		end

		logger.celebrate("Kerio VPN connection initiated!")
		raycastNotification.showHUD("🔐 Set Kerio VPN Connection")
	end)
end

return kerio
