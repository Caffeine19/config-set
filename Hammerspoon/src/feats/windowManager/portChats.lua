-- Port Chat Windows Module
-- Move chat app windows to a specific display
--
-- NOTE: utils has been split into modules. Use `js` for collection helpers
-- and `find` as a standalone finder function.

local js = require("utils.js")
local find = require("utils.find")
local log = require("utils.log")

local portChats = {}

-- Create a scoped logger for this module
local logger = log.createLogger("PORT-CHATS")

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
    logger.custom("📺", "Found", #screens, "display(s):")

    js.forEach(screens, function(screen, i)
        local name = screen:name()
        local id = screen:id()
        local frame = screen:frame()
        local uuid = screen:getUUID()
        local isMain = screen == hs.screen.mainScreen()

        logger.info(string.format("[%d] %s", i, name))
        logger.debug(string.format("    ID: %s", id))
        logger.debug(string.format("    UUID: %s", uuid))
        logger.debug(string.format("    Frame: x=%d, y=%d, w=%d, h=%d",
            frame.x, frame.y, frame.w, frame.h))
        logger.debug(string.format("    Main: %s", tostring(isMain)))
    end)

    logger.info("Use portChats.moveChatsToDisplay(index) to move chat windows")
    logger.info("Example: portChats.moveChatsToDisplay(2)")

    return screens
end

-- Find all windows belonging to chat apps
function portChats.findChatWindows()
    local chatWindows = js.flatMap(portChats.appList, function(appName)
        local app = hs.application.get(appName)
        if not app then
            logger.error(appName, "not running")
            return {}
        end

        local windows = app:allWindows()
        local validWindows = js.filter(windows, function(win)
            return win:isStandard() and win:isVisible()
        end)

        return js.map(validWindows, function(win)
            logger.custom("💬", "Found:", appName, "-", win:title() or "Untitled")
            return {
                window = win,
                appName = appName,
                title = win:title()
            }
        end)
    end)

    logger.info("Total: Found", #chatWindows, "chat window(s)")
    return chatWindows
end

-- Move all chat windows to the Sidecar display
function portChats.moveChatsToSidecar()
    local screens = hs.screen.allScreens()
    local targetScreen = find(screens, function(screen)
        return screen:name() == "Sidecar Display (AirPlay)"
    end)

    if not targetScreen then
        logger.error("Sidecar Display (AirPlay) not found")
        return false
    end

    local targetFrame = targetScreen:frame()

    logger.target("Moving chat windows to:", targetScreen:name())

    local chatWindows = portChats.findChatWindows()
    local movedCount = 0

    js.forEach(chatWindows, function(chatWin)
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

            logger.success("Moved:", chatWin.appName, "-", chatWin.title or "Untitled")
            movedCount = movedCount + 1
        else
            logger.custom("⏭︎", "Skip:", chatWin.appName, "already on target display")
        end
    end)

    logger.celebrate("Moved", movedCount, "window(s) to", targetScreen:name())
    return true
end

-- Move chat windows to display by name (partial match supported)
-- @param displayName: Name or partial name of the display
function portChats.moveChatsToDisplayByName(displayName)
    local screens = hs.screen.allScreens()

    local matchedScreen = find(screens, function(screen)
        return string.find(string.lower(screen:name()), string.lower(displayName))
    end)

    if matchedScreen then
        -- Find the index of the matched screen
        local matchedIndex = nil
        js.forEach(screens, function(screen, i)
            if screen:id() == matchedScreen:id() then
                matchedIndex = i
            end
        end)

        logger.search("Found display:", matchedScreen:name())
        return portChats.moveChatsToDisplay(matchedIndex)
    end

    logger.error("No display found matching:", displayName)
    return false
end

-- Add an app to the chat list
function portChats.addApp(appName)
    table.insert(portChats.appList, appName)
    logger.custom("➕", "Added", appName, "to chat app list")
end

-- Remove an app from the chat list
function portChats.removeApp(appName)
    local found = find(portChats.appList, function(name)
        return name == appName
    end)

    if found then
        portChats.appList = js.filter(portChats.appList, function(name)
            return name ~= appName
        end)
        logger.custom("➖", "Removed", appName, "from chat app list")
        return true
    end

    logger.error(appName, "not found in chat app list")
    return false
end

-- Show current app list
function portChats.showAppList()
    logger.custom("📋", "Chat applications:")
    for i, name in ipairs(portChats.appList) do
        logger.info(string.format("[%d] %s", i, name))
    end
end

return portChats
