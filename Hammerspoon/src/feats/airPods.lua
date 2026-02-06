local log = require("utils.log")
local raycastNotification = require("utils.raycastNotification")

-- Create a scoped logger for this module
local logger = log.createLogger("AIR-PODS")

-- Thanks https://blog.tonyding.net/archives/39/
-- And https://www.reddit.com/r/MacOS/comments/16wkyvu/airpods_defaulting_to_half_volume_whenever_they/

local airPods = {}

-- Configuration
local AIR_PODS_ALIAS = "CC-AirPods Pro"
local AIR_PODS_DEFAULT_VOLUME = 25
local MUTED_VOLUME = 0

-- Store the last default audio output device name
local lastOutputDeviceName = nil

-- Initialize with current device
local function initLastDevice()
	local device = hs.audiodevice.defaultOutputDevice()
	if device then
		lastOutputDeviceName = device:name()
		logger.debug("Initialized with device:", lastOutputDeviceName)
	end
end

-- Check if a device name matches AirPods
local function isAirPods(deviceName)
	return deviceName and string.find(deviceName, AIR_PODS_ALIAS)
end

-- Handle audio device changes
local function handleDeviceChanges()
	local currentDevice = hs.audiodevice.defaultOutputDevice()
	if currentDevice == nil then
		logger.error("No default audio output device found")
		return
	end

	local currentOutputDeviceName = currentDevice:name()

	-- Safety check: prevent nil errors
	if currentOutputDeviceName == nil or lastOutputDeviceName == nil then
		logger.debug("Device name is nil, skipping")
		return
	end

	-- Check if device actually changed
	if lastOutputDeviceName == currentOutputDeviceName then
		return
	end

	logger.info(
		"Audio device changed:",
		lastOutputDeviceName,
		"->",
		currentOutputDeviceName
	)

	-- If new device is AirPods (connected)
	if isAirPods(currentOutputDeviceName) then
		currentDevice:setVolume(AIR_PODS_DEFAULT_VOLUME)
		logger.success(
			"AirPods connected, volume set to",
			AIR_PODS_DEFAULT_VOLUME
		)
		raycastNotification.showHUD("🎧 AirPods connected")

		-- If old device was AirPods (disconnected)
	elseif isAirPods(lastOutputDeviceName) then
		currentDevice:setVolume(MUTED_VOLUME)
		logger.info("AirPods disconnected, volume muted")
		raycastNotification.showHUD("🔇 AirPods disconnected")
	end

	-- Update to current device name
	lastOutputDeviceName = currentOutputDeviceName
end

-- Initialize the audio device watcher
function airPods.init()
	initLastDevice()

	hs.audiodevice.watcher.setCallback(handleDeviceChanges)
	hs.audiodevice.watcher.start()

	logger.success("Audio device watcher started")
end

-- Stop the audio device watcher
function airPods.stop()
	hs.audiodevice.watcher.stop()
	logger.info("Audio device watcher stopped")
end

return airPods
