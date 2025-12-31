local find = require('find')
local raycastNotifications = require('raycastNotification')
local utils = require("utils")

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

    print("🔊 [ENDEL] togglePlayOrPause - endelApp=" .. hs.inspect(endelApp))

    local axApp = getEndelAxApp(endelApp)
    if not axApp then
        return
    end

    print("🔊 [ENDEL] togglePlayOrPause - axApp=" .. hs.inspect(axApp))


    local playButton = find.byDescriptionAndRole(axApp, "Play", 'AXButton')
    local pauseButton = find.byDescriptionAndRole(axApp, "Pause", 'AXButton')

    local playOrPauseButton = playButton or pauseButton

    if (not playOrPauseButton) then
        print("❌ [ENDEL] Play/Pause button not found")
        return
    end

    local success = playOrPauseButton:performAction("AXPress")
    if not success then
        print("❌ [ENDEL] Failed to toggle play/pause")
        raycastNotifications.showHUD("❌ Failed to toggle Endel play/pause")
        return
    end

    print("🎉 [ENDEL] Toggled play/pause successfully")
    if playButton then
        raycastNotifications.showHUD("🔊 Endel play started")
    else
        raycastNotifications.showHUD("🔇 Endel paused")
    end
end

-- tab:"Focus"|"Relax"|"Sleep"
local function toggleTabs(tab, endelApp)
    local tabElement = find.byRoleAndTitle(endelApp, tab)

    if not tabElement then
        return
    end

    tabElement:click()
end

local modeGroupList = {
    Focus = { "Focus", "Dynamic Focus", "Study", "Deeper Focus" },
    Relax = { "Relax" },
    Sleep = { "Sleep" },
}

function endel.setMode(mode)
    openEndel()


    local endelApp = getEndelApp()
    if not endelApp then
        return
    end

    local tabName = nil
    utils.forEachEntries(modeGroupList, function(k, modes)
        if not tabName and utils.includes(modes, mode) then
            tabName = k
        end
    end)

    if not tabName then
        return
    end

    toggleTabs(tabName, endelApp)

    local modeElement = find.byRoleAndTitle(endelApp, mode)
    if modeElement and modeElement.click then
        modeElement:click()
    end
end

return endel
