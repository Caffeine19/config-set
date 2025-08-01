-- Window Manager Module for Hammerspoon
-- Automatically manages new windows with configurable rules and blacklist
local utils = require("utils")
local windowManager = {}

-- Blacklist of applications that should not be maximized
local launchers = {"Raycast", "Alfred", "Hammerspoon"}
local games = {"Hearthstone"}
local baseList = {"Calculator", "System Preferences", "System Settings", "Control Center", "Hammerspoon", "Loop",
                  "Mouseposé", "Shottr"}
local blacklist = utils.mergeArrays(baseList, launchers, games)

-- Function to check if an application is blacklisted
local function isBlacklisted(appName)
    return utils.includes(blacklist, appName)
end

-- Function to check if window should be skipped based on specific conditions
local function shouldSkipWindow(win, appName)
    -- Skip Notion Command Search window
    if appName == "Notion" and win:title() == "Notion - Command Search" then
        print("[SKIP] Notion Command Search window")
        return true
    end

    -- Skip dialog windows
    if win:subrole() == "AXDialog" then
        print("[SKIP] " .. appName .. " - AXDialog subrole")
        return true
    end

    -- Skip system dialog windows
    if win:subrole() == "AXSystemDialog" then
        print("[SKIP] " .. appName .. " - AXSystemDialog subrole")
        return true
    end

    -- Add more specific window skip conditions here
    return false
end

-- Maximize window using Loop
local function maximizeWindowByLoop(win, appName)
    print("[MAXIMIZE] Using Loop for " .. appName)
    hs.execute("open -g loop://direction/maximize")
end

-- Maximize window using Window/Fill menu item
local function maximizeWindowByMenuItem(win, appName)
    local app = win:application()
    local menuItem = app:findMenuItem({"Window", "Fill"})
    if menuItem then
        local success = app:selectMenuItem({"Window", "Fill"})
        if success then
            print("[SUCCESS] Window/Fill menu selected for " .. appName)
        else
            print("[FAILED] Could not select Window/Fill for " .. appName)
        end
    else
        print("[FAILED] No Window/Fill menu for " .. appName)
    end
end

-- Maximize window using Raycast
local function maximizeWindowByRaycast(win, appName)
    print("[MAXIMIZE] Using Raycast for " .. appName)
    hs.execute("open -g raycast://extensions/raycast/window-management/maximize")
end

-- Main maximizeWindow function (choose method)
local function maximizeWindow(win, appName)
    -- Example: Try menuItem first, then Loop, then Raycast
    local app = win:application()
    local menuItem = app:findMenuItem({"Window", "Fill"})
    if menuItem then
        maximizeWindowByMenuItem(win, appName)
        -- maximizeWindowByLoop(win, appName)
    else
        -- You can change the order here if you want Loop or Raycast to be preferred
        -- maximizeWindowByLoop(win, appName)
        maximizeWindowByRaycast(win, appName)
    end
end

-- Main window creation handler
local function handleWindowCreated(win)
    local appName = win:application():name()

    -- Print window properties for debugging
    print("[DEBUG] Window created:")
    print("  App: " .. appName)
    print("  Title: " .. (win:title() or "No title"))
    -- print("  Frame: " .. hs.inspect(win:frame()))
    print("  Role: " .. (win:role() or "No role"))
    print("  Subrole: " .. (win:subrole() or "No subrole"))
    print("  ID: " .. (win:id() or "No ID"))
    print("  Is Standard: " .. tostring(win:isStandard()))
    print("  Is Minimized: " .. tostring(win:isMinimized()))
    print("  Is Visible: " .. tostring(win:isVisible()))

    -- Skip blacklisted applications
    if isBlacklisted(appName) then
        print("[SKIP] " .. appName .. " is blacklisted")
        return
    end

    -- Skip specific windows based on conditions
    if shouldSkipWindow(win, appName) then
        return
    end

    -- Attempt to maximize the window
    maximizeWindow(win, appName)
end

-- Initialize the window management functionality
function windowManager.init()
    -- Subscribe to window creation events
    hs.window.filter.default:subscribe(hs.window.filter.windowCreated, handleWindowCreated)
    print("[WINDOW-MANAGER] Window management initialized")
end

-- Maximize all existing windows
function windowManager.maximizeAllWindows()
    local allWindows = hs.window.allWindows()
    local processed = 0
    local skipped = 0

    print("[WINDOW-MANAGER] Starting to maximize all existing windows...")

    for _, win in ipairs(allWindows) do
        local appName = win:application():name()
        print("[DEBUG] Processing window for app: " .. appName)

        -- Skip if window is not standard or not visible
        -- if not win:isStandard() or not win:isVisible() or win:isMinimized() then
        --     print("[SKIP] " .. appName .. " - not standard/visible/minimized")
        --     skipped = skipped + 1
        --     goto continue
        -- end

        -- Skip blacklisted applications
        if isBlacklisted(appName) then
            print("[SKIP] " .. appName .. " is blacklisted")
            skipped = skipped + 1
            goto continue
        end

        -- Skip specific windows based on conditions
        if shouldSkipWindow(win, appName) then
            skipped = skipped + 1
            goto continue
        end

        -- Focus the window first, then maximize it
        print("[FOCUS] Bringing " .. appName .. " to front")
        win:focus()

        -- Small delay to ensure window is focused
        hs.timer.usleep(100000) -- 0.1 seconds

        -- Maximize the window
        maximizeWindow(win, appName)
        processed = processed + 1

        ::continue::
    end

    print("[WINDOW-MANAGER] Finished! Processed: " .. processed .. ", Skipped: " .. skipped)
end

-- Maximize all existing windows from all spaces
function windowManager.maximizeAllWindowsFromAllSpaces()
    local processed = 0
    local skipped = 0

    print("[WINDOW-MANAGER] Starting to maximize all existing windows across all spaces...")

    -- Get all applications first
    local allApps = hs.application.runningApplications()

    for _, app in ipairs(allApps) do
        local appName = app:name()
        local appWindows = app:allWindows()

        for _, win in ipairs(appWindows) do
            print("[DEBUG] Processing window for app: " .. appName)

            -- Skip if window is not standard
            if not win:isStandard() then
                print("[SKIP] " .. appName .. " - not standard window")
                skipped = skipped + 1
                goto continue
            end

            -- Skip blacklisted applications
            if isBlacklisted(appName) then
                print("[SKIP] " .. appName .. " is blacklisted")
                skipped = skipped + 1
                goto continue
            end

            -- Skip specific windows based on conditions
            if shouldSkipWindow(win, appName) then
                skipped = skipped + 1
                goto continue
            end

            -- Focus the window first, then maximize it
            print("[FOCUS] Bringing " .. appName .. " to front")
            win:focus()

            -- Small delay to ensure window is focused
            hs.timer.usleep(100000) -- 0.1 seconds

            -- Maximize the window
            maximizeWindow(win, appName)
            processed = processed + 1

            ::continue::
        end
    end

    print("[WINDOW-MANAGER] Finished! Processed: " .. processed .. ", Skipped: " .. skipped)
end

-- Get all windows information (for debugging)
function windowManager.getAllWindowsInfo()
    local allWindows = hs.window.allWindows()
    local info = {}

    for _, win in ipairs(allWindows) do
        local appName = win:application():name()
        table.insert(info, {
            app = appName,
            title = win:title() or "No title",
            id = win:id(),
            isStandard = win:isStandard(),
            isVisible = win:isVisible(),
            isMinimized = win:isMinimized(),
            frame = win:frame()
        })
    end

    return info
end

-- 

return windowManager

