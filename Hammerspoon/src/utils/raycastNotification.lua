-- Raycast Notification Module for Hammerspoon
-- Provides convenient functions to send notifications via Raycast Notification extension
local log = require("utils.log")

local raycastNotification = {}

-- Create a scoped logger for this module
local logger = log.createLogger("RAYCAST-NOTIFICATION")

-- Base function to send notification via Raycast
local function sendNotification(notificationType, background, title, message)
    if not title or title == "" then
        logger.error("Title is required")
        return false
    end

    -- Build simple JSON manually
    local jsonParts = { '"title":"' .. title .. '"' }

    -- Message only works with notification-center type
    if message and message ~= "" and notificationType == "notification-center" then
        table.insert(jsonParts, '"message":"' .. message .. '"')
    end

    if notificationType and notificationType ~= "" then
        table.insert(jsonParts, '"type":"' .. notificationType .. '"')
    end

    local jsonArgs = "{" .. table.concat(jsonParts, ",") .. "}"
    local encodedArgs = hs.http.encodeForQuery(jsonArgs)

    -- Build Raycast URL
    local baseUrl = "raycast://extensions/maxnyby/raycast-notification/index"
    local params = "arguments=" .. encodedArgs

    if background then
        params = "launchType=background&" .. params
    end

    local raycastUrl = baseUrl .. "?" .. params
    logger.link("URL:", raycastUrl)

    -- Execute the command
    local success = hs.execute("open -g \"" .. raycastUrl .. "\"")

    if success then
        logger.success("Sent:", title)
        return true
    else
        logger.error("Failed to send:", title)
        return false
    end
end

-- Show standard HUD notification (title only)
function raycastNotification.showHUD(title, background)
    if background == nil then background = true end
    return sendNotification("standard", background, title, nil)
end

-- Show success notification (title only)
function raycastNotification.showSuccess(title, background)
    if background == nil then background = false end
    return sendNotification("success", background, title, nil)
end

-- Show failure notification (title only)
function raycastNotification.showFailure(title, background)
    if background == nil then background = false end
    return sendNotification("failure", background, title, nil)
end

-- Show notification center notification (supports title and message)
function raycastNotification.showNotificationCenter(title, message, background)
    if background == nil then background = true end
    return sendNotification("notification-center", background, title, message)
end

-- Generic notification function with all options
function raycastNotification.notify(options)
    local title = options.title
    local message = options.message
    local notificationType = options.type or "standard"
    local background = options.background

    if background == nil then
        background = (notificationType == "standard" or notificationType == "notification-center")
    end

    return sendNotification(notificationType, background, title, message)
end

-- Convenience functions for common use cases

return raycastNotification
