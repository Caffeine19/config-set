-- Display-Audio Link Module for Hammerspoon
-- Automatically sets audio output device when a specific display is connected/disconnected

local log = require("utils.log")
local raycastNotification = require("utils.raycastNotification")
local js = require("utils.js")
local filter, find, forEach, includes, map =
	js.filter, js.find, js.forEach, js.includes, js.map

local displayAudioLink = {}

-- Create a scoped logger for this module
local logger = log.createLogger("DISPLAY-AUDIO-LINK")

-- Display-to-audio mappings
local DISPLAY_AUDIO_MAPPINGS = {
	-- { displayName = "LG UltraFine", audioDeviceName = "LG UltraFine Display Audio" },
	{ displayName = "Mi 27 NU", audioDeviceName = "Mi 27 NU" },
}

-- Fallback audio device when mapped display disconnects (nil = keep current)
local DEFAULT_AUDIO_DEVICE = nil

-- Track previously connected displays
local previousDisplays = {}

--- Get all currently connected display names
-- @return table Array of display names
local function getConnectedDisplayNames()
	local screens = hs.screen.allScreens()
	return map(screens, function(screen)
		return screen:name()
	end)
end

--- Check if a display name matches a partial pattern (case-insensitive)
-- @param displayName string The full display name
-- @param pattern string The pattern to match
-- @return boolean
local function displayMatches(displayName, pattern)
	if not displayName or not pattern then
		return false
	end
	return string.find(string.lower(displayName), string.lower(pattern)) ~= nil
end

--- Find audio device by name (partial match, case-insensitive)
-- @param deviceName string The device name to search for
-- @return hs.audiodevice|nil
local function findAudioDevice(deviceName)
	local devices = hs.audiodevice.allOutputDevices()
	return find(devices, function(device)
		local name = device:name()
		return name
			and string.find(string.lower(name), string.lower(deviceName))
				~= nil
	end)
end

--- Set audio output device by name
-- @param deviceName string The device name to set
-- @return boolean Success status
local function setAudioOutput(deviceName)
	local device = findAudioDevice(deviceName)
	if not device then
		logger.error("Audio device not found:", deviceName)
		return false
	end

	local success = device:setDefaultOutputDevice()
	if not success then
		logger.error("Failed to set audio output to:", deviceName)
		return false
	end

	logger.success("Audio output set to:", device:name())
	return true
end

--- Find matching mapping for a display
-- @param displayName string The display name to check
-- @return table|nil The matching mapping or nil
local function findMappingForDisplay(displayName)
	return find(DISPLAY_AUDIO_MAPPINGS, function(mapping)
		return displayMatches(displayName, mapping.displayName)
	end)
end

--- Handle display configuration changes
local function handleDisplayChange()
	local currentDisplays = getConnectedDisplayNames()

	logger.debug("Display configuration changed")
	logger.debug("Previous displays:", previousDisplays)
	logger.debug("Current displays:", currentDisplays)

	-- Find newly connected displays
	local newDisplays = filter(currentDisplays, function(display)
		return not includes(previousDisplays, display)
	end)

	-- Find disconnected displays
	local removedDisplays = filter(previousDisplays, function(display)
		return not includes(currentDisplays, display)
	end)

	-- Handle newly connected displays
	forEach(newDisplays, function(displayName)
		logger.info("Display connected:", displayName)

		local mapping = findMappingForDisplay(displayName)
		if not mapping then
			return
		end

		logger.link(
			"Found mapping:",
			displayName,
			"->",
			mapping.audioDeviceName
		)

		if setAudioOutput(mapping.audioDeviceName) then
			raycastNotification.showHUD(
				"🖥️ "
					.. displayName
					.. " → 🔊 "
					.. mapping.audioDeviceName
			)
		else
			raycastNotification.showFailure(
				"Failed to set audio: " .. mapping.audioDeviceName
			)
		end
	end)

	-- Handle disconnected displays (switch back to default if configured)
	if not DEFAULT_AUDIO_DEVICE then
		return
	end

	forEach(removedDisplays, function(displayName)
		logger.info("Display disconnected:", displayName)

		local mapping = findMappingForDisplay(displayName)
		if not mapping then
			return
		end

		logger.link("Reverting to default audio:", DEFAULT_AUDIO_DEVICE)

		if setAudioOutput(DEFAULT_AUDIO_DEVICE) then
			raycastNotification.showHUD(
				"🔊 Audio → " .. DEFAULT_AUDIO_DEVICE
			)
		end
	end)

	-- Update state
	previousDisplays = currentDisplays
end

--- Initialize the display-audio link watcher
function displayAudioLink.init()
	-- Initialize previous displays state
	previousDisplays = getConnectedDisplayNames()
	logger.debug("Initialized with displays:", previousDisplays)

	-- Start watching for display changes
	hs.screen.watcher.new(handleDisplayChange):start()

	logger.success("Display-audio link watcher started")
end

--- List all connected displays
function displayAudioLink.listDisplays()
	local displays = getConnectedDisplayNames()
	logger.info("Connected displays:")
	forEach(displays, function(display, i)
		logger.info("  " .. i .. ".", display)
	end)
	return displays
end

--- List all available audio output devices
function displayAudioLink.listAudioDevices()
	local devices = hs.audiodevice.allOutputDevices()
	logger.info("Available audio output devices:")
	forEach(devices, function(device, i)
		local name = device:name()
		local isDefault = device:isOutputDevice()
			and device == hs.audiodevice.defaultOutputDevice()
		local marker = isDefault and " (current)" or ""
		logger.info("  " .. i .. ".", name .. marker)
	end)
	return map(devices, function(d)
		return d:name()
	end)
end

return displayAudioLink
