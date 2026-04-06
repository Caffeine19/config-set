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

local function focusTextarea(app)
	local axApp = hs.axuielement.applicationElement(app)
	if not axApp then
		return
	end

	local textarea = find.element(axApp, { role = "AXTextArea" })
	if not textarea then
		return
	end

	textarea:setAttributeValue("AXFocused", true)
	logger.success("Focused ChatGPT textarea")
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
			focusTextarea(app)
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
