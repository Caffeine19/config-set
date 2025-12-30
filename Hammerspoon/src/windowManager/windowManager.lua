-- Window Manager Module for Hammerspoon
-- Provides automatic window management with configurable rules and application filtering
-- Features: auto-maximize on creation, bulk window processing, blacklist management
local utils = require("utils")
local raycastNotification = require("raycastNotification")
local ms = require("ms")
local blacklist = require("windowManager.blacklist")
local method = require("windowManager.method")

local windowManager = {}

-- Unified function to check if a window should be skipped for processing
local function checkWindow(win, appName)
    -- Skip if window is not standard or not visible
    if not win:isStandard() or not win:isVisible() or win:isMinimized() then
        print("⏭️ [SKIP] " .. appName .. " - not standard/visible or is minimized")
        return true
    end

    -- Skip dialog windows
    if win:subrole() == "AXDialog" then
        print("⏭️ [SKIP] " .. appName .. " - AXDialog subrole")
        return true
    end

    -- Skip system dialog windows
    if win:subrole() == "AXSystemDialog" then
        print("⏭️ [SKIP] " .. appName .. " - AXSystemDialog subrole")
        return true
    end

    -- Skip blacklisted applications
    if blacklist.isBlacklisted(appName) then
        print("🚫 [SKIP] " .. appName .. " is blacklisted")
        return true
    end

    -- Skip Notion Command Search window
    if appName == "Notion" and win:title() == "Notion - Command Search" then
        print("⏭️ [SKIP] Notion Command Search window")
        return true
    end


    -- Add more specific window skip conditions here
    return false
end

-- Calculate optimal delay before applying window management
-- Prevents visual glitches when windows have built-in scale/fade transitions
-- Applying window management too early can cause sluggish or jerky animations
local function getExtraDelay(win, appName)
    local delay = 0.16

    -- This is the weChat image preview window
    if appName == "WeChat" and win:title() == "Window" then
        print("⏳ [DELAY] WeChat image preview detected, applying longer delay")
        delay = 0.32
    end

    if appName == "Alacritty" then
        print("⏳ [DELAY] Alacritty detected, applying longer delay")
        delay = 0
    end

    print("⏳ [DELAY] Applying delay of " .. delay .. " seconds for " .. appName)
    return delay
end


-- Inspect window properties
local function inspectWinInfo(win)
    local appName = win:application():name()
    -- Print window properties for debugging
    print("🔍 [DEBUG] Window created:")
    print("  📘 App: " .. appName)
    print("  📝 Title: " .. (win:title() or "None"))
    print("  💼 Role: " .. (win:role() or "None"))
    print("  💼 Subrole: " .. (win:subrole() or "None"))

    print("  📏 Is Standard: " ..
        tostring(win:isStandard()) ..
        "  👁️ Is Minimized: " .. tostring(win:isMinimized()) .. "  👀 Is Visible: " .. tostring(win:isVisible()))
end

-- Main window creation handler
local function handleWindowCreated(win)
    inspectWinInfo(win)

    local appName = win:application():name()

    -- Check if window should be skipped
    if checkWindow(win, appName) then
        return
    end

    -- some window isn't focused when created, so focus it first
    win:focus()

    local delay = getExtraDelay(win, appName)

    hs.timer.doAfter(delay, function()
        local shouldCenter = blacklist.shouldCenterInsteadOfMax(appName)
        if shouldCenter then
            method.centerWindow(win, appName)
        else
            -- Attempt to maximize the window
            method.maximizeWindow(win, appName)
        end

        local action = shouldCenter and "Centered" or "Maximized"
        local title = string.format("💫 %s: %s", action, appName)
        raycastNotification.showHUD(title, true)
    end)
end

-- Initialize the window management functionality
function windowManager.init()
    -- Subscribe to window creation events
    hs.window.filter.default:subscribe(hs.window.filter.windowCreated, handleWindowCreated)
    print("🚀 [WINDOW-MANAGER] Window management initialized")
end

-- Common function to process and maximize a list of windows
local function processAndMaximizeWindows(windowList)
    local processed = 0
    local skipped = 0

    utils.forEach(windowList, function(win)
        local appName = win:application():name()
        print("🔍 [DEBUG] Processing window for app: " .. appName)

        -- Check if window should be skipped (unified function)
        if checkWindow(win, appName) then
            skipped = skipped + 1
            return
        end

        -- Focus the window first, then maximize/center it
        print("🎯 [FOCUS] Bringing " .. appName .. " to front")
        win:focus()

        -- Small delay to ensure window is focused
        hs.timer.usleep(ms.ms('0.1s'))

        -- Check if app should be centered instead of maximized
        if blacklist.shouldCenterInsteadOfMax(appName) then
            method.centerWindow(win, appName)
        else
            -- Use existing maximizeWindow function (Loop/Raycast/MenuItem)
            method.maximizeWindow(win, appName)
        end
        processed = processed + 1
    end)

    print("✅ [WINDOW-MANAGER] Finished! Processed: " .. processed .. ", Skipped: " .. skipped)

    -- Show success notification via Raycast with delay
    hs.timer.doAfter(0.2, function()
        local total = processed + skipped
        local title = string.format("☘️ Window Processing Complete - %d / %d", processed, total)
        raycastNotification.showHUD(title, true)
    end)

    return processed, skipped
end

-- Maximize all windows in the current screen
function windowManager.tidyMainScreen()
    print("🌟 [WINDOW-MANAGER] Starting to tidy main screen...")

    local title = string.format("🌟 Starting to Tidy Main Screen")
    raycastNotification.showHUD(title, true)

    -- Get the main (active) screen
    local mainScreen = hs.screen.mainScreen()

    local mainScreenWindows = hs.window.filter.new():setCurrentSpace(true):setScreens(mainScreen:getUUID()):getWindows()

    print("🔢 [DEBUG] Total windows found: " .. #mainScreenWindows)

    processAndMaximizeWindows(mainScreenWindows)
end

-- Maximize all existing windows
function windowManager.tidyAllScreens()
    print("💎 [WINDOW-MANAGER] Starting to tidy all screens...")

    local title = string.format("💎 Starting to Tidy All Screens")
    raycastNotification.showHUD(title, true)

    local allWindows = hs.window.allWindows()

    processAndMaximizeWindows(allWindows)
end

-- Maximize all existing windows from all spaces
function windowManager.tidyAllSpaces()
    print("🌌 [WINDOW-MANAGER] Starting to tidy all spaces...")

    local title = string.format("🌌 Starting to Tidy All Spaces")
    raycastNotification.showHUD(title, true)

    -- Get all spaces across all screens
    -- Example: screen1: [space 1, space 2 * active, space 3], screen2: [space 4, space 5 * active]
    local spacesTable = hs.spaces.allSpaces()
    if not spacesTable then
        print("❌ [ERROR] Could not get spaces table")
        raycastNotification.showHUD("❌ Error: Could not get spaces", true)
        return
    end

    -- Get currently active (visible) spaces - subset of spacesTable
    -- Example: activeSpaces = {screen1UUID: space2, screen2UUID: space5}
    local activeSpaces = hs.spaces.activeSpaces()

    print("📊 [DEBUG] All spaces: " .. hs.inspect(spacesTable))
    print("👁️ [DEBUG] Active spaces: " .. hs.inspect(activeSpaces))

    -- STEP 1: Process all windows in currently visible spaces efficiently
    print("⚡ [STEP 1] Processing visible spaces...")
    local visibleWindows = hs.window.allWindows()
    print("🪟 [DEBUG] Found " .. #visibleWindows .. " windows in visible spaces")

    local visibleProcessed, visibleSkipped = processAndMaximizeWindows(visibleWindows)
    print("✅ [STEP 1] Visible spaces complete: " .. visibleProcessed .. " processed, " .. visibleSkipped .. " skipped")

    -- STEP 2: Calculate non-visible spaces that need individual processing
    local nonVisibleSpaces = {}



    utils.forEachEntries(spacesTable, function(screenUUID, allSpaceIDs)
        local activeSpaceID = activeSpaces[screenUUID]

        nonVisibleSpaces = utils.merge(
            nonVisibleSpaces,
            utils.filter(
                allSpaceIDs,
                function(spaceID)
                    print("comparing spaceID", spaceID, "to activeSpaceID", activeSpaceID)
                    return spaceID ~= activeSpaceID
                end
            )
        )
    end)

    print("🌐 [DEBUG] Non-visible spaces to process: " .. #nonVisibleSpaces)
    print("��� [DEBUG] Non-visible space IDs: " .. hs.inspect(nonVisibleSpaces))

    if #nonVisibleSpaces == 0 then
        print("🎉 [COMPLETE] All windows processed from visible spaces only")
        raycastNotification.showHUD("🎉 Tidy All Spaces Complete - " .. visibleProcessed .. " windows", true)
        return
    end

    -- STEP 3: Process each non-visible space individually
    local currentSpaceIndex = 1
    local totalNonVisibleProcessed = 0

    local function processNextNonVisibleSpace()
        if currentSpaceIndex > #nonVisibleSpaces then
            -- All non-visible spaces processed - restore original active spaces
            print("🔄 [RESTORE] Restoring original active spaces...")

            utils.forEachEntries(activeSpaces, function(screenUUID, originalSpaceID)
                hs.spaces.gotoSpace(originalSpaceID)
            end)

            local totalProcessed = visibleProcessed + totalNonVisibleProcessed
            local finalTitle = string.format("🌌 Tidy All Spaces Complete - %d windows", totalProcessed)
            raycastNotification.showHUD(finalTitle, true)

            return
        end

        local spaceID = nonVisibleSpaces[currentSpaceIndex]
        print("🌐 [STEP 3] Processing non-visible space " ..
            currentSpaceIndex .. "/" .. #nonVisibleSpaces .. ": " .. spaceID)

        -- Switch to this specific space
        hs.spaces.gotoSpace(spaceID)

        -- Small delay to ensure space switch is complete
        hs.timer.doAfter(0.5, function()
            -- Get windows ONLY from this specific space (not all visible)
            local windowIDs = hs.spaces.windowsForSpace(spaceID)
            if not windowIDs then
                print("⚠️ [DEBUG] No windows found in space " .. spaceID)
                currentSpaceIndex = currentSpaceIndex + 1
                processNextNonVisibleSpace()
                return
            end

            print("🪟 [DEBUG] Found " .. #windowIDs .. " windows in space " .. spaceID)

            -- Convert window IDs to window objects (now accessible since we're in this space)
            local spaceWindows = {}

            utils.forEach(windowIDs, function(windowID)
                local window = hs.window.get(windowID)
                if not window then
                    return
                end

                table.insert(spaceWindows, window)
                print("✅ [DEBUG] Added window: " ..
                    (window:title() or "No title") .. " from " .. window:application():name())
            end)

            -- Process windows in this space
            if #spaceWindows > 0 then
                local processed, skipped = processAndMaximizeWindows(spaceWindows)
                totalNonVisibleProcessed = totalNonVisibleProcessed + processed
                print("✅ [DEBUG] Space " ..
                    spaceID .. " complete: " .. processed .. " processed, " .. skipped .. " skipped")
            end

            -- Continue to next space
            currentSpaceIndex = currentSpaceIndex + 1
            hs.timer.doAfter(0.2, processNextNonVisibleSpace)
        end)
    end

    -- Start processing non-visible spaces
    processNextNonVisibleSpace()
end

-- Common function to process and randomize a list of windows
local function processAndMessUpWindows(windowList)
    local processed = 0
    local skipped = 0

    utils.forEach(windowList, function(win)
        local appName = win:application():name()
        print("🔍 [DEBUG] Messing up window for app: " .. appName)

        -- Check if window should be skipped (unified function)
        if checkWindow(win, appName) then
            skipped = skipped + 1
            return
        end

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
            h = randomHeight
        }

        print("🎲 [MESS] " ..
            appName .. " -> pos(" .. randomX .. "," .. randomY .. ") size(" .. randomWidth .. "x" .. randomHeight .. ")")

        -- Apply the random frame
        win:setFrame(randomFrame)
        processed = processed + 1
    end)

    print("🎭 [WINDOW-MANAGER] Mess up finished! Processed: " .. processed .. ", Skipped: " .. skipped)

    -- Show completion notification
    hs.timer.doAfter(0.2, function()
        local total = processed + skipped
        local title = string.format("🎭 Window Chaos Complete - %d / %d", processed, total)
        raycastNotification.showHUD(title, true)
    end)

    return processed, skipped
end

-- Randomly position and size all windows across all spaces (chaos mode!)
function windowManager.messUpAllWindows()
    print("👻 [WINDOW-MANAGER] Starting to mess up all windows...")

    local title = string.format("👻 Starting Window Chaos Mode")
    raycastNotification.showHUD(title, true)

    -- Use the same efficient logic as tidyAllSpaces

    -- Get all spaces across all screens
    local spacesTable = hs.spaces.allSpaces()
    if not spacesTable then
        print("❌ [ERROR] Could not get spaces table")
        raycastNotification.showHUD("❌ Error: Could not get spaces", true)
        return
    end

    -- Get currently active (visible) spaces
    local activeSpaces = hs.spaces.activeSpaces()

    print("📊 [DEBUG] All spaces: " .. hs.inspect(spacesTable))
    print("👁️ [DEBUG] Active spaces: " .. hs.inspect(activeSpaces))

    -- STEP 1: Process all windows in currently visible spaces efficiently
    print("⚡ [STEP 1] Messing up visible spaces...")
    local visibleWindows = hs.window.allWindows()
    print("🪟 [DEBUG] Found " .. #visibleWindows .. " windows in visible spaces")

    local visibleProcessed, visibleSkipped = processAndMessUpWindows(visibleWindows)
    print("✅ [STEP 1] Visible spaces chaos complete: " ..
        visibleProcessed .. " messed up, " .. visibleSkipped .. " skipped")

    -- STEP 2: Calculate non-visible spaces that need individual processing
    local nonVisibleSpaces = {}
    for screenUUID, allSpaceIDs in pairs(spacesTable) do
        local activeSpaceID = activeSpaces[screenUUID]
        for _, spaceID in ipairs(allSpaceIDs) do
            if spaceID ~= activeSpaceID then
                table.insert(nonVisibleSpaces, spaceID)
            end
        end
    end

    print("🌐 [DEBUG] Non-visible spaces to mess up: " .. #nonVisibleSpaces)
    print("📋 [DEBUG] Non-visible space IDs: " .. hs.inspect(nonVisibleSpaces))

    if #nonVisibleSpaces == 0 then
        print("🎉 [COMPLETE] All windows messed up from visible spaces only")
        raycastNotification.showHUD("👻 Window Chaos Complete - " .. visibleProcessed .. " windows", true)
        return
    end

    -- STEP 3: Process each non-visible space individually
    local currentSpaceIndex = 1
    local totalNonVisibleProcessed = 0

    local function messUpNextNonVisibleSpace()
        if currentSpaceIndex > #nonVisibleSpaces then
            -- All non-visible spaces processed - restore original active spaces
            print("🔄 [RESTORE] Restoring original active spaces...")
            for screenUUID, originalSpaceID in pairs(activeSpaces) do
                hs.spaces.gotoSpace(originalSpaceID)
            end

            local totalProcessed = visibleProcessed + totalNonVisibleProcessed
            local finalTitle = string.format("👻 Window Chaos Complete - %d windows messed up", totalProcessed)
            raycastNotification.showHUD(finalTitle, true)
            return
        end

        local spaceID = nonVisibleSpaces[currentSpaceIndex]
        print("🌐 [STEP 3] Messing up non-visible space " ..
            currentSpaceIndex .. "/" .. #nonVisibleSpaces .. ": " .. spaceID)

        -- Switch to this specific space
        hs.spaces.gotoSpace(spaceID)

        -- Small delay to ensure space switch is complete
        hs.timer.doAfter(0.5, function()
            -- Get windows ONLY from this specific space
            local windowIDs = hs.spaces.windowsForSpace(spaceID)
            if not windowIDs then
                print("⚠️ [DEBUG] No windows found in space " .. spaceID)
                currentSpaceIndex = currentSpaceIndex + 1
                messUpNextNonVisibleSpace()
                return
            end

            print("🪟 [DEBUG] Found " .. #windowIDs .. " windows in space " .. spaceID)

            -- Convert window IDs to window objects
            local spaceWindows = {}
            for _, windowID in ipairs(windowIDs) do
                local window = hs.window.get(windowID)
                if window then
                    table.insert(spaceWindows, window)
                    print("✅ [DEBUG] Added window: " ..
                        (window:title() or "No title") .. " from " .. window:application():name())
                end
            end

            -- Mess up windows in this space
            if #spaceWindows > 0 then
                local processed, skipped = processAndMessUpWindows(spaceWindows)
                totalNonVisibleProcessed = totalNonVisibleProcessed + processed
                print("✅ [DEBUG] Space " ..
                    spaceID .. " chaos complete: " .. processed .. " messed up, " .. skipped .. " skipped")
            end

            -- Continue to next space
            currentSpaceIndex = currentSpaceIndex + 1
            hs.timer.doAfter(0.2, messUpNextNonVisibleSpace)
        end)
    end

    -- Start messing up non-visible spaces
    messUpNextNonVisibleSpace()
end

return windowManager
