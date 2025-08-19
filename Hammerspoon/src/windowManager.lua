-- Window Manager Module for Hammerspoon
-- Provides automatic window management with configurable rules and application filtering
-- Features: auto-maximize on creation, bulk window processing, blacklist management
local utils = require("utils")
local raycastNotification = require("raycastNotification")
local windowManager = {}

-- Application blacklist - windows from these apps will not be auto-maximized
-- Organized by category for easier maintenance
local systemApps = {
    "Calculator", "System Preferences", "System Settings", "Control Center"
}
local launchers = { "Raycast", "Alfred" }
local games = { "Hearthstone" }
local baseList = { "Hammerspoon", "Loop",
    "Mouseposé", "Shottr", "Pictogram", "Xiaomi Home", "AutoSwitchInput Pro" }
local blacklist = utils.mergeArrays(systemApps, baseList, launchers, games)

-- Check if application is in the blacklist
local function isBlacklisted(appName)
    return utils.includes(blacklist, appName)
end

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
    if isBlacklisted(appName) then
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

-- Maximize window using Loop
local function maximizeWindowByLoop(win, appName)
    print("🔗 [MAXIMIZE] Using Loop for " .. appName)
    hs.execute("open -g loop://direction/maximize")
end

-- Maximize window using Window/Fill menu item
local function maximizeWindowByMenuItem(win, appName)
    local app = win:application()
    local menuItem = app:findMenuItem({ "Window", "Fill" })

    if not menuItem then
        print("❌ [FAILED] No Window/Fill menu for " .. appName)
        return false
    end

    -- Window/Fill menu exists, use select menu item to maximize the window
    local success = app:selectMenuItem({ "Window", "Fill" })
    if success then
        print("✅ [SUCCESS] Window/Fill menu selected for " .. appName)
        return true
    else
        print("❌ [FAILED] Could not select Window/Fill for " .. appName)
        return false
    end
end

-- Maximize window using Raycast
local function maximizeWindowByRaycast(win, appName)
    print("🚀 [MAXIMIZE] Using Raycast for " .. appName)
    hs.execute("open -g raycast://extensions/raycast/window-management/maximize")
end

-- Main maximizeWindow function (choose method)
local function maximizeWindow(win, appName)
    -- Try menuItem first, then fallback to Raycast
    if maximizeWindowByMenuItem(win, appName) then
        return
    end

    -- Fallback to Raycast if menuItem method failed
    maximizeWindowByRaycast(win, appName)
    -- Alternative: You can also try Loop method
    -- maximizeWindowByLoop(win, appName)
end

-- Calculate optimal delay before applying window management
-- Prevents visual glitches when windows have built-in scale/fade transitions
-- Applying window management too early can cause sluggish or jerky animations
local function getExtraDelay(win, appName)
    local delay = 0.1 -- Default delay in milliseconds

    -- This is the weChat image preview window
    if appName == "WeChat" and win:title() == "window" then
        delay = 0.2 -- 1 second delay
    end
    return delay
end

-- Main window creation handler
local function handleWindowCreated(win)
    local appName = win:application():name()

    -- Print window properties for debugging
    print("🔍 [DEBUG] Window created:")
    print("  📘 App: " .. appName)
    print("  📝 Title: " .. (win:title() or "No title"))
    -- print("  Frame: " .. hs.inspect(win:frame()))
    print("  💼 Role: " .. (win:role() or "No role"))
    print("  💼 Subrole: " .. (win:subrole() or "No subrole"))
    -- print("  🆔 ID: " .. (win:id() or "No ID"))
    print("  📏 Is Standard: " ..
        tostring(win:isStandard()) ..
        "  👁️ Is Minimized: " .. tostring(win:isMinimized()) .. "  👀 Is Visible: " .. tostring(win:isVisible()))

    -- Check if window should be skipped
    if checkWindow(win, appName) then
        return
    end

    local delay = getExtraDelay(win, appName)

    hs.timer.doAfter(delay, function()
        -- Attempt to maximize the window
        maximizeWindow(win, appName)
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

        -- Focus the window first, then maximize it
        print("🎯 [FOCUS] Bringing " .. appName .. " to front")
        win:focus()

        -- Small delay to ensure window is focused
        hs.timer.usleep(100000) -- 0.1 seconds

        -- Use existing maximizeWindow function (Loop/Raycast/MenuItem)
        maximizeWindow(win, appName)
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

-- Maximize all existing windows
function windowManager.maximizeAllWindows()
    local allWindows = hs.window.allWindows()
    print("🔄 [WINDOW-MANAGER] Starting to maximize all existing windows...")

    processAndMaximizeWindows(allWindows)
end

-- Maximize all existing windows from all spaces
function windowManager.maximizeAllWindowsFromAllSpaces()
    print("🌌 [WINDOW-MANAGER] Starting to maximize all existing windows across all spaces...")

    -- Get all applications first and collect their windows
    local allApps = hs.application.runningApplications()

    local windowList = utils.flatMap(allApps, function(app)
        return app:allWindows()
    end)

    processAndMaximizeWindows(windowList)
end

-- Maximize all windows in the current screen
function windowManager.maximizeAllWindowInCurrentSpace()
    print("🌟 [WINDOW-MANAGER] Starting to maximize all windows in current screen...")

    -- Get the main (active) screen
    local mainScreen = hs.screen.mainScreen()

    local mainScreenWindows = hs.window.filter.new():setCurrentSpace(true):setScreens(mainScreen:getUUID()):getWindows()

    print("🔢 [DEBUG] Total windows found: " .. #mainScreenWindows)

    processAndMaximizeWindows(mainScreenWindows)
end

return windowManager
