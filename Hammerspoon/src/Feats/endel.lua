local find = require("Utils.find")
local js = require("Utils.js")
local flatMap = js.flatMap
local promise = require("Utils.promise")
local raycastNotifications = require("Utils.raycastNotification")
local log = require("Utils.log")

local async = promise.async

-- Create a scoped logger for this module
local logger = log.createLogger("ENDEL")

local endel = {}

local function openEndel()
	hs.application.launchOrFocus("Endel")
end

local function getEndelApp()
	local endelApp = hs.application.find("Endel")
	return endelApp
end

local function getEndelAxApp(endelApp)
	local axApp = hs.axuielement.applicationElement(endelApp)
	return axApp
end

function endel.togglePlayOrPause()
	openEndel()

	local endelApp = getEndelApp()
	if not endelApp then
		return
	end

	logger.debug("togglePlayOrPause - endelApp=", endelApp)

	local axApp = getEndelAxApp(endelApp)
	if not axApp then
		return
	end

	logger.debug("togglePlayOrPause - axApp=", axApp)

	local playButton = find.byDescriptionAndRole(axApp, "Play", "AXButton")
	local pauseButton = find.byDescriptionAndRole(axApp, "Pause", "AXButton")

	local playOrPauseButton = playButton or pauseButton

	if not playOrPauseButton then
		logger.error("Play/Pause button not found")
		return
	end

	local success = playOrPauseButton:performAction("AXPress")
	if not success then
		logger.error("Failed to toggle play/pause")
		raycastNotifications.showHUD("⚠️ Failed to toggle Endel play/pause")
		return
	end

	logger.celebrate("Toggled play/pause successfully")
	if playButton then
		raycastNotifications.showHUD("🔊 Endel play started")
	else
		raycastNotifications.showHUD("🔇 Endel paused")
	end
end

local modeGroupList = {
	Focus = {
		"Focus",
		"Colored Noises",
		"Dynamic Focus",
		"Study",
		"Deeper Focus",
		"Solfeggio Tones",
	},
	Relax = {
		"Relax",
		"8D Odyssey",
		"Nature Elements",
		"Spatial Orbit",
		"Recovery",
		"Wiggly Wisdom",
	},
	Sleep = {
		"Sleep",
		"Rainy Outside",
		"Wind Down",
		"Hibernation",
		"AI Lullaby",
	},
}

-- Flatten modeGroupList into an ordered list for index-based lookup
local modeOrder = flatMap({ "Focus", "Relax", "Sleep" }, function(group)
	return modeGroupList[group]
end)

function endel.setMode_async(mode)
	return async(function()
		openEndel()
		-- @copilot await sleep

		await(promise.sleep(0.8))

		local endelApp = getEndelApp()
		if not endelApp then
			return
		end

		logger.debug("setMode - endelApp=", endelApp)

		local axApp = getEndelAxApp(endelApp)
		if not axApp then
			return
		end

		logger.debug("setMode - axApp=", axApp)

		-- Find the index of the mode in the ordered list
		local modeIndex = nil
		for i, m in ipairs(modeOrder) do
			if m == mode then
				modeIndex = i
				break
			end
		end

		if not modeIndex then
			logger.error("Mode not found in modeOrder:", mode)
			return
		end

		-- Find all SoundscapeButton link elements (mode icons in the footer)
		local buttons = find.allElements(
			axApp,
			{ role = "AXLink", domClassList = "SoundscapeButton" }
		)
		logger.debug("setMode - found", #buttons, "SoundscapeButton(s)")

		local target = buttons[modeIndex]
		if not target then
			logger.error(
				"SoundscapeButton not found at index",
				modeIndex,
				"for mode:",
				mode
			)
			return
		end

		logger.debug("setMode - selected mode element=", target)
		target:performAction("AXPress")
	end)
end

return endel
