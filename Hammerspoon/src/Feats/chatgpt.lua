-- ChatGPT Focus Module for Hammerspoon
-- When the ChatGPT launcher panel appears (AXSystemDialog, empty title), focus its textarea.
-- Uses hs.axuielement.observer since the panel is invisible to hs.window.filter.

local find = require("Utils.find")
local log = require("Utils.log")

local logger = log.createLogger("CHATGPT-FOCUS")

local chatgptFocus = {}

local APP_NAME = "ChatGPT"

local observer
local appWatcher

-- Search for textarea within the specific window element, not the whole app tree
local function focusTextarea(windowElement)
	local textarea = find.element(windowElement, { role = "AXTextArea" })
	if not textarea then
		return
	end

	local position = textarea:attributeValue("AXPosition")
	local size = textarea:attributeValue("AXSize")
	if not position or not size then
		return
	end

	hs.eventtap.leftClick({
		x = position.x + size.w / 2,
		y = position.y + size.h / 2,
	})
	logger.success("Clicked ChatGPT textarea")
end

local function attachObserver(app)
	if observer then
		observer:stop()
	end

	local ok, obs = pcall(hs.axuielement.observer.new, app:pid())
	if not ok or not obs then
		return
	end

	local axApp = hs.axuielement.applicationElement(app)

	obs:addWatcher(axApp, "AXFocusedWindowChanged")
	obs:callback(function(_, element)
		hs.timer.doAfter(0.1, function()
			local title = element:attributeValue("AXTitle")
			if title and title ~= "" then
				return
			end
			-- Pass the specific empty-title window, not the whole app
			focusTextarea(element)
		end)
	end)
	obs:start()
	observer = obs

	logger.debug("AX observer attached to ChatGPT")
end

function chatgptFocus.init()
	appWatcher = hs.application.watcher.new(function(appName, eventType, app)
		if appName ~= APP_NAME then
			return
		end

		if eventType == hs.application.watcher.terminated then
			if not observer then
				return
			end
			observer:stop()
			observer = nil
			return
		end

		if eventType ~= hs.application.watcher.launched then
			return
		end

		hs.timer.doAfter(1, function()
			attachObserver(app)
		end)
	end)
	appWatcher:start()

	local app = hs.application.find(APP_NAME)
	if not app then
		logger.start("ChatGPT focus initialized")
		return
	end

	attachObserver(app)
	logger.start("ChatGPT focus initialized")
end

return chatgptFocus
