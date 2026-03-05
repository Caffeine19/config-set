-- Focus Warp Module for Hammerspoon
-- Handles post-layout activation issues for newly created Warp windows

local log = require("Utils.log")

local logger = log.createLogger("WINDOW-MANAGER")

--- Left click a Warp window to ensure terminal input focus is truly active.
--- Sometimes a newly created Warp window appears active but does not accept input.
--- @param win hs.window
--- @param appName string
local function focusWarpWindow(win, appName)
	if appName ~= "Warp" then
		return
	end

	hs.timer.doAfter(2, function()
		local frame = win:frame()
		local clickPoint =
			{ x = frame.x + frame.w / 2, y = frame.y + frame.h / 2 }
		hs.eventtap.leftClick(clickPoint)
		logger.debug("Left clicked Warp window at center position")
	end)
end

return focusWarpWindow
