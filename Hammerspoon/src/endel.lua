local find = require('find')
local raycastNotifications = require('raycastNotification')
local uitls=require("utils")

local endel = {}

function openEndel()
    hs.application.launchOrFocus("Endel")
end

function getEndelApp()
    local endelApp = hs.application.find("Endel")
    return endelApp
end

function togglePlayOrPause()
    openEndel()

    local endelApp = getEndelApp()
    if not endelApp then
        return
    end


    local playOrPauseButton = find.byRoleAndTitle(endelApp, "Play/Pause")

    if not playOrPauseButton then
        return
    end

    playOrPauseButton:click()
end

-- tab:"Focus"|"Relax"|"Sleep"
function toggleTabs(
    tab,endelApp)

    local tabElement = find.byRoleAndTitle(endelApp, tab)

    if not tabElement then
        return
    end

    tabElement:click()
end


local modeList={
    "Focus":{
        "Focus",
        "Dynamic Focus",
        "Study",
        "Deeper Focus",
    },
    "Relax":{
        "Relax",
    },
    "Sleep":{
        "Sleeep"
    }
}

function setMode (mode)
    openEndel()

    local endelApp=getEndelApp()
    if not endelApp then
        return
    end

    local tab= utils.find(
        modeList,
        function (modesGroup)
            return
            modesGroup[1]==mode
        end
    )

    toggleTabs(tab,endelApp)

    local modeElement = find.byRoleAndTitle(endelApp, mode)

    modeElement.click()
end

return endel
