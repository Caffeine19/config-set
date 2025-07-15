-- Window Manager Module for Hammerspoon
-- Automatically manages new windows with configurable rules and blacklist
local utils = require("utils")
local windowManager = {}

-- Configuration
local launchers = {"Raycast", "Alfred", "Hammerspoon"}

-- Blacklist of applications that should not be maximized
local blacklist = utils.mergeArrays({"Calculator", "System Preferences", "System Settings", "Hammerspoon", "Loop"},
    launchers)

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

    -- Add more specific window skip conditions here
    return false
end

-- Function to attempt window maximization
local function maximizeWindow(win, appName)
    print("[AUTO-MAXIMIZE] Processing " .. appName)

    -- 1. Check if Window/Fill menu item exists
    local app = win:application()
    local menuItem = app:findMenuItem({"Window", "Fill"})

    if menuItem then
        -- Window/Fill menu exists, use select menu item to maximize the window
        local success = app:selectMenuItem({"Window", "Fill"})
        if success then
            print("[SUCCESS] Window/Fill menu selected for " .. appName)
        else
            print("[FAILED] Could not select Window/Fill for " .. appName)
        end
    else
        -- Window/Fill menu not available, use Raycast maximize command
        print("[FALLBACK] Using Raycast for " .. appName .. " (no Window/Fill menu)")
        hs.execute("open -g raycast://extensions/raycast/window-management/maximize")
    end
end

-- Main window creation handler
local function handleWindowCreated(win)
    local appName = win:application():name()

    -- Print window properties for debugging
    print("[DEBUG] Window created:")
    print("  App: " .. appName)
    print("  Title: " .. (win:title() or "No title"))
    print("  Frame: " .. hs.inspect(win:frame()))
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

return windowManager
