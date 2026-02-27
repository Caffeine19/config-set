-- Window Manager Module for Hammerspoon
-- Provides automatic window management with configurable rules and application filtering
-- Features: auto-maximize on creation, bulk window processing, blacklist management
local config = require("feats.windowManager.config")

local js = require("utils.js")
local diff, filter, flat, forEach, forEachAsync, map, values =
	js.diff, js.filter, js.flat, js.forEach, js.forEachAsync, js.map, js.values
local log = require("utils.log")
local method = require("feats.windowManager.method")
local promise = require("utils.promise")
local raycastNotification = require("utils.raycastNotification")

local async, await = promise.async, promise.await

-- Create a scoped logger for this module
local logger = log.createLogger("WINDOW-MANAGER")

local windowManager = {}

-- Unified function to check if a window should be skipped for processing
local function checkWindow(win, appName)
	-- Skip if window is not standard or not visible
	if not win:isStandard() or not win:isVisible() or win:isMinimized() then
		logger.custom(
			"⏭︎",
			"Skip:",
			appName,
			"- not standard/visible or is minimized"
		)
		return true
	end

	-- Skip fullscreen windows
	if win:isFullScreen() then
		logger.custom("⏭︎", "Skip:", appName, "- fullscreen")
		return true
	end

	-- Skip dialog windows
	if win:subrole() == "AXDialog" then
		logger.custom("⏭︎", "Skip:", appName, "- AXDialog subrole")
		return true
	end

	-- Skip system dialog windows
	if win:subrole() == "AXSystemDialog" then
		logger.custom("⏭︎", "Skip:", appName, "- AXSystemDialog subrole")
		return true
	end

	-- Skip blacklisted applications
	local isBlacklisted, reason = config.isBlacklisted(appName, win)
	if isBlacklisted then
		logger.custom("⏭", "Skip:", reason)
		return true
	end

	return false
end

-- Calculate optimal delay before applying window management
-- Prevents visual glitches when windows have built-in scale/fade transitions
-- Applying window management too early can cause sluggish or jerky animations
local function getExtraDelay(win, appName)
	local delay = 0.3

	-- This is the weChat image preview window
	if appName == "WeChat" and win:title() == "Window" then
		logger.wait("WeChat image preview detected, applying longer delay")
		delay = 0.32
	end

	if appName == "Alacritty" then
		logger.wait("Alacritty detected, applying longer delay")
		delay = 0
	end

	logger.wait("Applying delay of", delay, "seconds for", appName)
	return delay
end

-- Inspect window properties
local function inspectWinInfo(win)
	local appName = win:application():name()
	local title = win:title()
	-- Handle nil or empty string for title
	local displayTitle = (title and title ~= "") and title or "(empty)"
	-- Print window properties for debugging
	logger.custom("🥑", "Window created:")
	logger.custom("📦", "App:", appName, "| Title:", displayTitle)
	logger.debug(
		"Role:",
		win:role() or "None",
		"| Subrole:",
		win:subrole() or "None"
	)
	logger.debug(
		"Is Standard:",
		win:isStandard(),
		"Is Minimized:",
		win:isMinimized(),
		"Is Visible:",
		win:isVisible()
	)
end

-- Main window creation handler
local function handleWindowCreated(win)
	inspectWinInfo(win)

	local app = win:application()
	if not app then
		logger.error("Application not found")
		return
	end

	local appName = app:name()

	-- Check if window should be skipped
	if checkWindow(win, appName) then
		return
	end

	-- some window isn't focused when created, so focus it first
	win:focus()

	local delay = getExtraDelay(win, appName)

	hs.timer.doAfter(delay, function()
		local shouldCenter = config.shouldCenterInsteadOfMax(appName)
		if shouldCenter then
			method.center(win, appName)
		else
			-- Attempt to maximize the window
			method.maximize(win, appName)
		end

		local action = shouldCenter and "Centered" or "Tiled"
		local title = string.format("💫 Auto %s: %s", action, appName)
		raycastNotification.showHUD(title)
	end)
end

-- Window filter reference for pausing/resuming during bulk operations
local wf

--- Wrap an async function to pause the window creation handler during execution.
--- Automatically resumes after the inner function completes (including early returns).
local function withPausedHandler(fn)
	return async(function()
		if wf then
			wf:pause()
			logger.debug("Paused window creation handler")
		end

		fn()

		if wf then
			wf:resume()
			logger.debug("Resumed window creation handler")
		end
	end)
end

-- Initialize the window management functionality
function windowManager.init()
	-- Subscribe to window creation events
	wf = hs.window.filter.default
	wf:subscribe(hs.window.filter.windowCreated, handleWindowCreated)
	logger.start("Window management initialized")
end

-- Common function to process and maximize a list of windows
local function processAndMaximizeWindows_async(windowList)
	return async(function()
		local processed = 0
		local skipped = 0

		await(forEachAsync(windowList, function(win)
			local appName = win:application():name()
			logger.debug("Processing window for app:", appName)

			-- Check if window should be skipped (unified function)
			if checkWindow(win, appName) then
				skipped = skipped + 1
				return
			end

			-- Focus the window first, then maximize/center it
			logger.target("Bringing", appName, "to front")
			win:focus()

			-- Small delay to ensure window is focused
			await(promise.sleep(0.4))

			-- Check if app should be centered instead of maximized
			if config.shouldCenterInsteadOfMax(appName) then
				method.center(win, appName)
			else
				-- Use existing maximize function (Loop/Raycast/MenuItem)
				method.maximize(win, appName)
			end
			processed = processed + 1
		end))

		logger.success("Finished! Processed:", processed, ", Skipped:", skipped)

		return { processed, skipped }
	end)
end

-- Maximize all windows in the current screen
function windowManager.tidyMainScreen_async()
	return withPausedHandler(function()
		logger.custom("🌟", "Starting to tidy main screen...")

		raycastNotification.showHUD("🌟 Starting to Tidy Main Screen")

		local mainScreen = hs.screen.mainScreen()
		local mainScreenWindows = hs.window.filter
			.new()
			:setCurrentSpace(true)
			:setScreens(mainScreen:getUUID())
			:getWindows()

		logger.debug("Total windows found:", #mainScreenWindows)

		await(processAndMaximizeWindows_async(mainScreenWindows))

		raycastNotification.showHUD("🌟 Tidy Main Screen Complete")
	end)
end

-- Maximize all existing windows
function windowManager.tidyAllScreens_async()
	return withPausedHandler(function()
		logger.custom("💎", "Starting to tidy all screens...")

		raycastNotification.showHUD("💎 Starting to Tidy All Screens")

		local allWindows = hs.window.allWindows()

		await(processAndMaximizeWindows_async(allWindows))

		raycastNotification.showHUD("💎 Tidy All Screens Complete")
	end)
end

--- Map a callback over windows from all spaces (active + non-active).
--- Handles space discovery, fullscreen filtering, space switching, and restoration.
--- The callback receives a window list and should return { processed, skipped }.
--- It can be sync or async (awaitable).
--- @param callback fun(windowList: table): table -- returns { processed, skipped }
--- @param opts { emoji: string, startHUD: string, completeHUD: string }
local function mapWindowsFromAllSpaces_async(callback, opts)
	return withPausedHandler(function()
		local emoji = opts.emoji

		logger.custom(emoji, opts.startHUD)
		raycastNotification.showHUD(emoji .. " " .. opts.startHUD)

		-- All spaces ids
		-- Form: {screen1: [space 1, space 2 * active, space 3], screen2: [space 4, space 5 * active]}
		-- To: [space1, space2, space3, space4, space5]
		local allSpaceIds = flat(values(hs.spaces.allSpaces() or {}))
		logger.debug("All space IDs:", allSpaceIds)
		if #allSpaceIds == 0 then
			logger.error("Could not get all spaces")
			raycastNotification.showHUD(
				"⚠️ Error: Could not get all spaces"
			)
			return
		end

		-- Filter out fullscreen/tiled spaces (no need to process)
		allSpaceIds = filter(allSpaceIds, function(spaceID)
			local spaceType = hs.spaces.spaceType(spaceID)
			if spaceType == "fullscreen" then
				logger.custom("⏭︎", "Skip fullscreen space:", spaceID)
				return false
			end
			return true
		end)
		logger.debug("User space IDs (excluding fullscreen):", allSpaceIds)

		-- Active(visible) space ids
		-- From: {screen1: space 2 *active, screen2: space 5 *active}
		-- To: [space2, space5]
		local activeSpaceIds = values(hs.spaces.activeSpaces() or {})
		logger.debug("Active space IDs:", activeSpaceIds)
		if #activeSpaceIds == 0 then
			logger.error("Could not get active spaces")
			raycastNotification.showHUD(
				"⚠️ Error: Could not get active spaces"
			)
			return
		end

		-- STEP 1: Process all windows in currently active(visible) spaces
		logger.custom("⚡", "[STEP 1] Processing active spaces...")
		local activeWindows = hs.window.allWindows()
		logger.debug("Found", #activeWindows, "windows in active spaces")

		local result = await(callback(activeWindows))
		local activeProcessed, activeSkipped = result[1], result[2]
		logger.success(
			"[STEP 1] Active spaces complete:",
			activeProcessed,
			"processed,",
			activeSkipped,
			"skipped"
		)

		raycastNotification.showHUD("⌛ Active Spaces Complete")
		await(promise.sleep(1))

		-- STEP 2: Calculate non-active spaces (all - active)
		local nonActiveSpaceIds = diff(allSpaceIds, activeSpaceIds)

		logger.debug("Non-active spaces to process:", #nonActiveSpaceIds)
		logger.debug("Non-active space IDs:", nonActiveSpaceIds)

		if #nonActiveSpaceIds == 0 then
			logger.celebrate("All windows processed from active spaces only")
			raycastNotification.showHUD(emoji .. " " .. opts.completeHUD)
			return
		end

		-- STEP 3: Process each non-active space individually
		local totalNonActiveProcessed = 0

		await(forEachAsync(nonActiveSpaceIds, function(spaceID, i)
			raycastNotification.showHUD(
				"⏳ Keep running... (" .. i .. "/" .. #nonActiveSpaceIds .. ")"
			)
			await(promise.sleep(1))

			logger.custom(
				"🌐",
				"[STEP 3] Processing non-active space",
				i .. "/" .. #nonActiveSpaceIds .. ":",
				spaceID
			)

			-- Switch to this specific space
			hs.spaces.gotoSpace(spaceID)
			await(promise.sleep(0.2))

			local windowIDs = hs.spaces.windowsForSpace(spaceID)
			if not windowIDs then
				logger.error("No windows found in space", spaceID)
				return
			end

			logger.debug("Found", #windowIDs, "windows in space", spaceID)

			-- Convert window IDs to window objects (now accessible since we're in this space)
			local spaceWindows = filter(
				map(windowIDs, function(windowID)
					local window = hs.window.get(windowID)
					if not window then
						return nil
					end

					logger.debug(
						"Added window:",
						(window:title() or "No title"),
						"from",
						window:application():name()
					)
					return window
				end),
				function(window)
					return window ~= nil
				end
			)

			-- Process windows in this space
			if #spaceWindows > 0 then
				local spaceResult = await(callback(spaceWindows))
				local processed, skipped = spaceResult[1], spaceResult[2]

				totalNonActiveProcessed = totalNonActiveProcessed + processed
				logger.debug(
					"Space",
					spaceID,
					"complete:",
					processed,
					"processed,",
					skipped,
					"skipped"
				)
			end

			await(promise.sleep(0.2))
		end))

		-- Restore original active spaces
		logger.custom("🔄", "Restoring original active spaces...")
		forEach(activeSpaceIds, function(spaceId)
			hs.spaces.gotoSpace(spaceId)
		end)

		raycastNotification.showHUD(emoji .. " " .. opts.completeHUD)
	end)
end

-- Maximize all existing windows from all spaces
function windowManager.tidyAllSpaces_async()
	return mapWindowsFromAllSpaces_async(processAndMaximizeWindows_async, {
		emoji = "🪩",
		startHUD = "Starting to Tidy All Spaces",
		completeHUD = "Tidy All Spaces Complete",
	})
end

-- Generate a random frame for a window within its screen bounds
local function getRandomFrame(win)
	-- Get the screen this window is on
	local screen = win:screen()
	local screenFrame = screen:frame()

	-- Generate random position and size
	-- Keep window at least 200x150 pixels and at most 80% of screen
	local minWidth, minHeight = 200, 150
	local maxWidth = math.floor(screenFrame.w * 0.8)
	local maxHeight = math.floor(screenFrame.h * 0.8)

	local randomWidth = math.random(minWidth, maxWidth)
	local randomHeight = math.random(minHeight, maxHeight)

	-- Random position but keep at least 50px visible on screen
	local margin = 50
	local maxX = screenFrame.x + screenFrame.w - randomWidth - margin
	local maxY = screenFrame.y + screenFrame.h - randomHeight - margin
	local minX = screenFrame.x + margin
	local minY = screenFrame.y + margin

	local randomX = math.random(minX, maxX)
	local randomY = math.random(minY, maxY)

	-- Create the random frame
	local randomFrame = {
		x = randomX,
		y = randomY,
		w = randomWidth,
		h = randomHeight,
	}

	return randomFrame
end

-- Common function to process and randomize a list of windows
local function processAndMessUpWindows_async(windowList)
	return async(function()
		local processed = 0
		local skipped = 0

		forEach(windowList, function(win)
			local appName = win:application():name()
			logger.debug("Messing up window for app:", appName)

			-- Check if window should be skipped (unified function)
			if checkWindow(win, appName) then
				skipped = skipped + 1
				return
			end

			local randomFrame = getRandomFrame(win)

			-- Apply the random frame
			win:setFrame(randomFrame)
			processed = processed + 1
		end)

		logger.custom(
			"👻",
			"Mess up finished! Processed:",
			processed,
			", Skipped:",
			skipped
		)

		return { processed, skipped }
	end)
end

-- Randomly position and size all windows across all spaces (chaos mode!)
function windowManager.messUpAllSpaces_async()
	return mapWindowsFromAllSpaces_async(processAndMessUpWindows_async, {
		emoji = "👻",
		startHUD = "Starting Window Chaos Mode",
		completeHUD = "Window Chaos Complete",
	})
end

return windowManager
