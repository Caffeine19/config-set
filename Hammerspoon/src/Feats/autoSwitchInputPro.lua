-- AutoSwitchInput Pro Watcher
-- Periodically checks if "AutoSwitchInput Pro" is running.
-- If not, sends a Raycast notification and launches the app.
local raycastNotification = require("Utils.raycastNotification")
local log = require("Utils.log")

local logger = log.createLogger("AUTO-SWITCH-INPUT-PRO")

local APP_NAME = "AutoSwitchInput Pro"
-- Check interval in seconds
local CHECK_INTERVAL = 60

local autoSwitchInputPro = {}

local timer = nil

local function check()
	local app = hs.application.find(APP_NAME)
	if app then
		return
	end

	logger.info(APP_NAME .. " is not running, launching...")
	raycastNotification.showHUD(
		"⌨️ " .. APP_NAME .. " is not running, launching..."
	)
	hs.application.open(APP_NAME)
end

function autoSwitchInputPro.init()
	logger.start("Starting watcher for " .. APP_NAME)
	-- Run an immediate check on init
	-- check()
	timer = hs.timer.doEvery(CHECK_INTERVAL, check)
end

function autoSwitchInputPro.stop()
	if timer then
		timer:stop()
		timer = nil
	end
end

return autoSwitchInputPro
