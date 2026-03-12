-- Window operation methods for Window Manager
local log = require("Utils.log")

local method = {}

-- Create a scoped logger for this module
local logger = log.createLogger("WINDOW-MANAGER")

-- ── Loop methods ────────────────────────────────────────────────────────────
method.loop = {}

function method.loop.maximize(_, appName)
	logger.link("Using Loop for", appName)
	hs.execute("open -g loop://direction/maximize")
end

function method.loop.center(_, appName)
	logger.link("Using Loop for", appName)
	hs.execute("open -g loop://direction/center")
end

-- ── Raycast methods ──────────────────────────────────────────────────────────
-- Docs: https://manual.raycast.com/window-management
method.raycast = {}

local RAYCAST_WM = "raycast://extensions/raycast/window-management/"

-- ── Maximize / Fullscreen ───────────────────────────────────────────────────

function method.raycast.maximize(_, appName)
	logger.start("Using Raycast [maximize] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "maximize")
end

function method.raycast.almostMaximize(_, appName)
	logger.start("Using Raycast [almost-maximize] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "almost-maximize")
end

function method.raycast.maximizeHeight(_, appName)
	logger.start("Using Raycast [maximize-height] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "maximize-height")
end

function method.raycast.maximizeWidth(_, appName)
	logger.start("Using Raycast [maximize-width] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "maximize-width")
end

function method.raycast.toggleFullscreen(_, appName)
	logger.start("Using Raycast [toggle-fullscreen] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "toggle-fullscreen")
end

-- ── Halves ──────────────────────────────────────────────────────────────────

function method.raycast.leftHalf(_, appName)
	logger.start("Using Raycast [left-half] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "left-half")
end

function method.raycast.rightHalf(_, appName)
	logger.start("Using Raycast [right-half] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "right-half")
end

function method.raycast.topHalf(_, appName)
	logger.start("Using Raycast [top-half] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "top-half")
end

function method.raycast.bottomHalf(_, appName)
	logger.start("Using Raycast [bottom-half] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "bottom-half")
end

-- ── Center variations ───────────────────────────────────────────────────────

function method.raycast.center(_, appName)
	logger.start("Using Raycast [center] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "center")
end

function method.raycast.centerHalf(_, appName)
	logger.start("Using Raycast [center-half] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "center-half")
end

function method.raycast.centerThird(_, appName)
	logger.start("Using Raycast [center-third] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "center-third")
end

function method.raycast.centerTwoThirds(_, appName)
	logger.start("Using Raycast [center-two-thirds] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "center-two-thirds")
end

function method.raycast.centerThreeFourths(_, appName)
	logger.start("Using Raycast [center-three-fourths] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "center-three-fourths")
end

-- ── Thirds ──────────────────────────────────────────────────────────────────

function method.raycast.firstThird(_, appName)
	logger.start("Using Raycast [first-third] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "first-third")
end

function method.raycast.lastThird(_, appName)
	logger.start("Using Raycast [last-third] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "last-third")
end

function method.raycast.topThird(_, appName)
	logger.start("Using Raycast [top-third] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "top-third")
end

function method.raycast.bottomThird(_, appName)
	logger.start("Using Raycast [bottom-third] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "bottom-third")
end

function method.raycast.firstTwoThirds(_, appName)
	logger.start("Using Raycast [first-two-thirds] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "first-two-thirds")
end

function method.raycast.lastTwoThirds(_, appName)
	logger.start("Using Raycast [last-two-thirds] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "last-two-thirds")
end

function method.raycast.topTwoThirds(_, appName)
	logger.start("Using Raycast [top-two-thirds] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "top-two-thirds")
end

function method.raycast.bottomTwoThirds(_, appName)
	logger.start("Using Raycast [bottom-two-thirds] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "bottom-two-thirds")
end

-- ── Fourths ─────────────────────────────────────────────────────────────────

function method.raycast.firstFourth(_, appName)
	logger.start("Using Raycast [first-fourth] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "first-fourth")
end

function method.raycast.secondFourth(_, appName)
	logger.start("Using Raycast [second-fourth] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "second-fourth")
end

function method.raycast.thirdFourth(_, appName)
	logger.start("Using Raycast [third-fourth] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "third-fourth")
end

function method.raycast.lastFourth(_, appName)
	logger.start("Using Raycast [last-fourth] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "last-fourth")
end

-- ── Quarters ────────────────────────────────────────────────────────────────

function method.raycast.topLeftQuarter(_, appName)
	logger.start("Using Raycast [top-left-quarter] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "top-left-quarter")
end

function method.raycast.topRightQuarter(_, appName)
	logger.start("Using Raycast [top-right-quarter] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "top-right-quarter")
end

function method.raycast.bottomLeftQuarter(_, appName)
	logger.start("Using Raycast [bottom-left-quarter] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "bottom-left-quarter")
end

function method.raycast.bottomRightQuarter(_, appName)
	logger.start("Using Raycast [bottom-right-quarter] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "bottom-right-quarter")
end

-- ── Sixths ──────────────────────────────────────────────────────────────────

function method.raycast.topLeftSixth(_, appName)
	logger.start("Using Raycast [top-left-sixth] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "top-left-sixth")
end

function method.raycast.topCenterSixth(_, appName)
	logger.start("Using Raycast [top-center-sixth] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "top-center-sixth")
end

function method.raycast.topRightSixth(_, appName)
	logger.start("Using Raycast [top-right-sixth] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "top-right-sixth")
end

function method.raycast.bottomLeftSixth(_, appName)
	logger.start("Using Raycast [bottom-left-sixth] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "bottom-left-sixth")
end

function method.raycast.bottomCenterSixth(_, appName)
	logger.start("Using Raycast [bottom-center-sixth] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "bottom-center-sixth")
end

function method.raycast.bottomRightSixth(_, appName)
	logger.start("Using Raycast [bottom-right-sixth] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "bottom-right-sixth")
end

-- ── Three Fourths ───────────────────────────────────────────────────────────

function method.raycast.firstThreeFourths(_, appName)
	logger.start("Using Raycast [first-three-fourths] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "first-three-fourths")
end

function method.raycast.lastThreeFourths(_, appName)
	logger.start("Using Raycast [last-three-fourths] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "last-three-fourths")
end

function method.raycast.topThreeFourths(_, appName)
	logger.start("Using Raycast [top-three-fourths] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "top-three-fourths")
end

function method.raycast.bottomThreeFourths(_, appName)
	logger.start("Using Raycast [bottom-three-fourths] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "bottom-three-fourths")
end

-- ── Move ────────────────────────────────────────────────────────────────────

function method.raycast.moveUp(_, appName)
	logger.start("Using Raycast [move-up] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "move-up")
end

function method.raycast.moveDown(_, appName)
	logger.start("Using Raycast [move-down] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "move-down")
end

function method.raycast.moveLeft(_, appName)
	logger.start("Using Raycast [move-left] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "move-left")
end

function method.raycast.moveRight(_, appName)
	logger.start("Using Raycast [move-right] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "move-right")
end

-- ── Other ───────────────────────────────────────────────────────────────────

function method.raycast.restore(_, appName)
	logger.start("Using Raycast [restore] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "restore")
end

function method.raycast.reasonableSize(_, appName)
	logger.start("Using Raycast [reasonable-size] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "reasonable-size")
end

function method.raycast.previousDisplay(_, appName)
	logger.start("Using Raycast [previous-display] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "previous-display")
end

function method.raycast.nextDisplay(_, appName)
	logger.start("Using Raycast [next-display] for", appName)
	hs.execute("open -g " .. RAYCAST_WM .. "next-display")
end

-- ── Menu item methods ────────────────────────────────────────────────────────
method.menuitem = {}

function method.menuitem.maximize(win, appName)
	local app = win:application()
	local menuItem = app:findMenuItem({ "Window", "Fill" })

	if not menuItem then
		logger.error("No Window/Fill menu for", appName)
		return false
	end

	-- Window/Fill menu exists, use select menu item to maximize the window
	local success = app:selectMenuItem({ "Window", "Fill" })
	if success then
		logger.success("Window/Fill menu selected for", appName)
		return true
	else
		logger.error("Could not select Window/Fill for", appName)
		return false
	end
end

-- ── Top-level helpers (choose method) ───────────────────────────────────────

-- Maximize: try menuitem first, fallback to Raycast
function method.maximize(win, appName)
	if method.menuitem.maximize(win, appName) then
		return
	end

	-- Fallback to Raycast if menuitem method failed
	method.raycast.maximize(win, appName)
	-- Alternative: method.loop.maximize(win, appName)
end

-- Center: use Loop by default
function method.center(win, appName)
	method.loop.center(win, appName)
	-- Alternative: method.raycast.center(win, appName)
end

return method
