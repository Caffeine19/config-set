local ax = hs.axuielement

local js = require("utils.js")
local log = require("utils.log")

-- Focus utilities for interacting with windows near the mouse cursor
local focus = {}

-- Create a scoped logger for this module
local logger = log.createLogger("FOCUS")

local DOUBLE_TAP_TIMEOUT = 0.32 -- seconds allowed between Command taps

local lastCommandTap = 0
local commandIsDown = false
local commandWatcher

local function pointInsideFrame(point, frame)
	return point.x >= frame.x
		and point.x <= frame.x + frame.w
		and point.y >= frame.y
		and point.y <= frame.y + frame.h
end

local function firstWindowUnderPointByOrderedWindows(point)
	local ordered = hs.window.orderedWindows()

	return js.find(ordered, function(win, index)
		logger.debug(
			string.format(
				"ordered window %d -> %s | %s",
				index,
				(win:application() and win:application():name()) or "Unknown",
				win:title() or "(no title)"
			)
		)

		if win:isStandard() and win:isVisible() and not win:isMinimized() then
			if pointInsideFrame(point, win:frame()) then
				return true
			end
		end

		return false
	end)
end

local function windowFromAccessibilityAtPoint(point)
	if not ax then
		return nil
	end

	local systemWide = ax.systemWideElement()
	if not systemWide then
		return nil
	end

	local element = systemWide:elementAtPosition(point.x, point.y)

	while element do
		local role = element:attributeValue("AXRole")

		local function asWindow(candidate)
			if candidate and type(candidate.asHSWindow) == "function" then
				local ok, win = pcall(candidate.asHSWindow, candidate)
				if ok and win and win:isVisible() and not win:isMinimized() then
					return win
				end
			end
			return nil
		end

		if js.includes({ "AXWindow", "AXSheet" }, role) then
			local win = asWindow(element)
			if win then
				return win
			end
		end

		local owningWindow = element:attributeValue("AXWindow")
		local winFromOwning = asWindow(owningWindow)
		if winFromOwning then
			return winFromOwning
		end

		element = element:attributeValue("AXParent")
	end

	return nil
end

local function firstWindowUnderPoint(point)
	local axWindow = windowFromAccessibilityAtPoint(point)
	if axWindow and axWindow:isVisible() and not axWindow:isMinimized() then
		return axWindow
	end

	return firstWindowUnderPointByOrderedWindows(point)
end

function focus.focusWindowUnderMouse()
	local mousePosition = hs.mouse.absolutePosition()
	local targetWindow = firstWindowUnderPoint(mousePosition)

	if targetWindow then
		targetWindow:focus()
		return targetWindow
	end

	return nil
end

local function onlyCommandActive(flags)
	if not flags.cmd then
		return false
	end

	local disallowedModifiers = { "alt", "ctrl", "fn", "shift", "capslock" }
	local activeModifier = js.find(disallowedModifiers, function(modifier)
		return flags[modifier]
	end)

	return activeModifier == nil
end

local function handleCommandDoubleTap(flags)
	local now = hs.timer.secondsSinceEpoch()

	if now - lastCommandTap <= DOUBLE_TAP_TIMEOUT then
		focus.focusWindowUnderMouse()
		lastCommandTap = 0
	else
		lastCommandTap = now
	end
end

local function handleFlagsChanged(event)
	local flags = event:getFlags()
	local cmdDown = flags.cmd

	if cmdDown and not commandIsDown then
		if onlyCommandActive(flags) then
			handleCommandDoubleTap(flags)
		else
			lastCommandTap = 0
		end

		commandIsDown = true
	elseif not cmdDown and commandIsDown then
		commandIsDown = false
	end

	return false
end

local function ensureWatcher()
	if commandWatcher then
		return
	end

	commandWatcher = hs.eventtap.new(
		{ hs.eventtap.event.types.flagsChanged },
		handleFlagsChanged
	)
	commandWatcher:start()
end

function focus.init()
	ensureWatcher()
	logger.target("Double Command watcher enabled")
end

function focus.stop()
	if commandWatcher then
		commandWatcher:stop()
		commandWatcher = nil
	end
end

return focus
