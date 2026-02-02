-- space.lua: Space management utilities for Hammerspoon
local log = require('utils.log')

local space = {}

-- Create a scoped logger for this module
local logger = log.createLogger("SPACE")

-- Remove the current space (move to previous, then remove original)
function space.removeCurrentSpace()
    local currentFocusedSpaceId = hs.spaces.focusedSpace()
    local currentScreen = hs.screen.mainScreen()
    local spacesInCurrentScreen = hs.spaces.spacesForScreen(currentScreen)
    logger.debug("spacesInCurrentScreen=", spacesInCurrentScreen)

    local prevSpaceId = nil
    for i, id in ipairs(spacesInCurrentScreen) do
        if id == currentFocusedSpaceId and i > 1 then
            prevSpaceId = spacesInCurrentScreen[i - 1]
            break
        end
    end
    if prevSpaceId then
        logger.info("Switching to previous space:", prevSpaceId)
        hs.spaces.gotoSpace(prevSpaceId)
        hs.timer.doAfter(1, function()
            logger.info("Removing original space:", currentFocusedSpaceId)
            local ok, err = hs.spaces.removeSpace(currentFocusedSpaceId)
            if not ok then
                logger.error("Remove failed:", err)
            else
                logger.success("Space removed successfully!")
            end
        end)
    else
        logger.error("No previous space found, cannot remove current space.")
    end
end

return space
