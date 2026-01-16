local find = require('utils.find')
local js = require("utils.js")
local ms = require("utils.ms")
local raycastNotifications = require('utils.raycastNotification')

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
local function toggleTabs(tab, axApp)
    local tabElement = find.byDescriptionAndRole(axApp, tab, 'AXButton')

    if not tabElement then
        print("❌ [ENDEL] Tab element not found for tab: " .. tab)
        return nil
    end

    print("🔊 [ENDEL] toggleTabs - tabElement=" .. hs.inspect(tabElement))

    local success = tabElement:performAction("AXPress")
    if not success then
        print("❌ [ENDEL] Failed to toggle tab: " .. tab)
        return nil
    end

    return tabElement
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

    print("🔊 [ENDEL] togglePlayOrPause - endelApp=" .. hs.inspect(endelApp))

    local axApp = getEndelAxApp(endelApp)
    if not axApp then
        return
    end

    print("🔊 [ENDEL] togglePlayOrPause - axApp=" .. hs.inspect(axApp))


    local tabName = nil
    js.forEachEntries(modeGroupList, function(k, modes)
        if not tabName and js.includes(modes, mode) then
            tabName = k
        end
    end)

    if not tabName then
        return
    end
    print("🔊 [ENDEL] setMode - tabName=", tabName)

    local tabElement = toggleTabs(tabName, axApp)
    if not tabElement then
        return
    end

    -- Find all candidate mode buttons and choose one that is not the tab element
    local candidates = find.allElements(axApp, { role = 'AXButton', description = mode })
    print("🔊 [ENDEL] setMode - found " .. tostring(#candidates) .. " candidate(s) for mode: " .. mode)

    local target = nil
    for _, c in ipairs(candidates) do
        print("🔊 [ENDEL] setMode - candidate element=", tostring(c), tostring(tabElement))
        if tostring(c) ~= tostring(tabElement) then
            target = c
            break
        end
    end

    if not target then
        print("❌ [ENDEL] No suitable mode button found (candidates may all be the tab)")
        return
    end

    hs.timer.usleep(ms.ms('0.8s'))
    print("🔊 [ENDEL] setMode - selected mode element=" .. hs.inspect(target))
    target:performAction("AXPress")
end

return endel
