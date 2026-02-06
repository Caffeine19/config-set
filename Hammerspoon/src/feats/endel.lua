local find = require("utils.find")
local js = require("utils.js")
local forEachEntries, includes = js.forEachEntries, js.includes
local promise = require("utils.promise")
local raycastNotifications = require("utils.raycastNotification")
local log = require("utils.log")

local async, await = promise.async, promise.await

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

-- tab:"Focus"|"Relax"|"Sleep"
local function toggleTabs(tab, axApp)
	local tabElement = find.byDescriptionAndRole(axApp, tab, "AXButton")

	if not tabElement then
		logger.error("Tab element not found for tab:", tab)
		return nil
	end

	logger.debug("toggleTabs - tabElement=", tabElement)

	local success = tabElement:performAction("AXPress")
	if not success then
		logger.error("Failed to toggle tab:", tab)
		return nil
	end

	return tabElement
end

local modeGroupList = {
	Focus = { "Focus", "Dynamic Focus", "Study", "Deeper Focus" },
	Relax = { "Relax" },
	Sleep = { "Sleep" },
}

function endel.setMode_async(mode)
	return async(function()
		openEndel()

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

		local tabName = nil
		forEachEntries(modeGroupList, function(k, modes)
			if not tabName and includes(modes, mode) then
				tabName = k
			end
		end)

		if not tabName then
			return
		end
		logger.debug("setMode - tabName=", tabName)

		local tabElement = toggleTabs(tabName, axApp)
		if not tabElement then
			return
		end

		-- Find all candidate mode buttons and choose one that is not the tab element
		local candidates =
			find.allElements(axApp, { role = "AXButton", description = mode })
		logger.debug(
			"setMode - found",
			#candidates,
			"candidate(s) for mode:",
			mode
		)

		local target = nil
		for _, c in ipairs(candidates) do
			logger.debug("setMode - candidate element=", c, tabElement)
			if tostring(c) ~= tostring(tabElement) then
				target = c
				break
			end
		end

		if not target then
			logger.error(
				"No suitable mode button found (candidates may all be the tab)"
			)
			return
		end

		await(promise.sleep(0.8))
		logger.debug("setMode - selected mode element=", target)
		target:performAction("AXPress")
	end)
end

return endel
