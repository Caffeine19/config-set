-- Port Chat Windows Module
-- Move chat app windows to a specific display

local utils = require("utils")

local portChats = {}

-- List of chat applications to manage
portChats.appList = {
    "ChatGPT",
    "WeChat",
    "Spark",
}

-- List all available displays with their details
-- Call this function to identify which display you want to use
function portChats.listDisplays()
    local screens = hs.screen.allScreens()
    print("📺 [DISPLAYS] Found " .. #screens .. " display(s):")
    print("=" .. string.rep("=", 60))

    utils.forEach(screens, function(screen, i)
        local name = screen:name()
        local id = screen:id()
        local frame = screen:frame()
        local uuid = screen:getUUID()
        local isMain = screen == hs.screen.mainScreen()

        print(string.format("  [%d] %s", i, name))
        print(string.format("      ID: %s", id))
        print(string.format("      UUID: %s", uuid))
        print(string.format("      Frame: x=%d, y=%d, w=%d, h=%d",
            frame.x, frame.y, frame.w, frame.h))
        print(string.format("      Main: %s", tostring(isMain)))
        print("")
    end)

    print("=" .. string.rep("=", 60))
    print("💡 Use portChats.moveChatsToDisplay(index) to move chat windows")
    print("   Example: portChats.moveChatsToDisplay(2)")

    return screens
end

-- Find all windows belonging to chat apps
function portChats.findChatWindows()
    local chatWindows = utils.flatMap(portChats.appList, function(appName)
        local app = hs.application.get(appName)
        if not app then
            print(string.format("⚠️ [NOT RUNNING] %s", appName))
            return {}
        end

        local windows = app:allWindows()
        local validWindows = utils.filter(windows, function(win)
            return win:isStandard() and win:isVisible()
        end)

        return utils.map(validWindows, function(win)
            print(string.format("💬 [FOUND] %s - %s", appName, win:title() or "Untitled"))
            return {
                window = win,
                appName = appName,
                title = win:title()
            }
        end)
    end)

    print(string.format("📊 [TOTAL] Found %d chat window(s)", #chatWindows))
    return chatWindows
end

-- Move all chat windows to the Sidecar display
function portChats.moveChatsToSidecar()
    local screens = hs.screen.allScreens()
    local targetScreen = utils.find(screens, function(screen)
        return screen:name() == "Sidecar Display (AirPlay)"
    end)

    if not targetScreen then
        print("❌ [ERROR] Sidecar Display (AirPlay) not found")
        return false
    end

    local targetFrame = targetScreen:frame()

    print(string.format("🎯 [TARGET] Moving chat windows to: %s", targetScreen:name()))

    local chatWindows = portChats.findChatWindows()
    local movedCount = 0

    utils.forEach(chatWindows, function(chatWin)
        local win = chatWin.window
        local currentScreen = win:screen()

        if currentScreen:id() ~= targetScreen:id() then
            -- Move window to center of target screen
            local winFrame = win:frame()
            local newX = targetFrame.x + (targetFrame.w - winFrame.w) / 2
            local newY = targetFrame.y + (targetFrame.h - winFrame.h) / 2

            win:setFrame({
                x = newX,
                y = newY,
                w = winFrame.w,
                h = winFrame.h
            })

            print(string.format("✅ [MOVED] %s - %s", chatWin.appName, chatWin.title or "Untitled"))
            movedCount = movedCount + 1
        else
            print(string.format("⏭️ [SKIP] %s already on target display", chatWin.appName))
        end
    end)

    print(string.format("📦 [DONE] Moved %d window(s) to %s", movedCount, targetScreen:name()))
    return true
end

-- Move chat windows to display by name (partial match supported)
-- @param displayName: Name or partial name of the display
function portChats.moveChatsToDisplayByName(displayName)
    local screens = hs.screen.allScreens()

    local matchedScreen = utils.find(screens, function(screen)
        return string.find(string.lower(screen:name()), string.lower(displayName))
    end)

    if matchedScreen then
        -- Find the index of the matched screen
        local matchedIndex = nil
        utils.forEach(screens, function(screen, i)
            if screen:id() == matchedScreen:id() then
                matchedIndex = i
            end
        end)

        print(string.format("🔍 [MATCH] Found display: %s", matchedScreen:name()))
        return portChats.moveChatsToDisplay(matchedIndex)
    end

    print(string.format("❌ [ERROR] No display found matching: %s", displayName))
    return false
end

-- Add an app to the chat list
function portChats.addApp(appName)
    table.insert(portChats.appList, appName)
    print(string.format("➕ [ADDED] %s to chat app list", appName))
end

-- Remove an app from the chat list
function portChats.removeApp(appName)
    local found = utils.find(portChats.appList, function(name)
        return name == appName
    end)

    if found then
        portChats.appList = utils.filter(portChats.appList, function(name)
            return name ~= appName
        end)
        print(string.format("➖ [REMOVED] %s from chat app list", appName))
        return true
    end

    print(string.format("⚠️ [NOT FOUND] %s in chat app list", appName))
    return false
end

-- Show current app list
function portChats.showAppList()
    print("📋 [APP LIST] Chat applications:")
    for i, name in ipairs(portChats.appList) do
        print(string.format("  [%d] %s", i, name))
    end
end

return portChats
