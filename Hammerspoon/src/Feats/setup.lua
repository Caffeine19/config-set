local log = require("Utils.log")
local js = require("Utils.js")
local forEachAsync = js.forEachAsync
local promise = require("Utils.promise")
local raycastNotification = require("Utils.raycastNotification")
local windowManager = require("Feats.windowManager.windowManager")
local portChats = require("Feats.windowManager.portChats")

local async, await = promise.async, promise.await

local logger = log.createLogger("SETUP")

local setup = {}

-- Press Enter on WeChat to dismiss the login prompt / confirm dialog
local function pressEnterOnWeChat_async()
	local wechat = hs.application.find("WeChat")
	if not wechat then
		logger.info("WeChat not running, skipping")
		return
	end

	local wins = wechat:allWindows()
	if #wins == 0 then
		logger.info("No WeChat windows found, skipping")
		return
	end

	local win = wins[1]
	win:focus()
	await(promise.sleep(0.3))
	hs.eventtap.keyStroke({}, "return")
	logger.success("Pressed Enter on WeChat")
end

-- Close all Warp terminal windows for a clean start
local function closeAllWarpWindows_async()
	local warp = hs.application.find("Warp")
	if not warp then
		logger.info("Warp not running, skipping")
		return
	end

	local wins = warp:allWindows()
	if #wins == 0 then
		logger.info("No Warp windows found, skipping")
		return
	end

	await(forEachAsync(wins, function(win)
		win:close()
		await(promise.sleep(0.1))
	end))
	logger.success("Closed " .. #wins .. " Warp window(s)")
end

-- Move mouse to the center of the primary screen (the one set in macOS System Settings)
local function centerMouse()
	local frame = hs.screen.primaryScreen():frame()
	hs.mouse.setAbsolutePosition({
		x = frame.x + frame.w / 2,
		y = frame.y + frame.h / 2,
	})
	logger.success("Mouse centered on primary screen")
end

function setup.init_async()
	async(function()
		logger.start("Running setup")
		raycastNotification.showHUD("🚀 Running setup...")

		-- Pause window manager auto-tidy during setup to prevent interference
		windowManager.pauseHandler()

		await(promise.sleep(4))

		-- Press Enter on WeChat
		await(pressEnterOnWeChat_async())
		await(promise.sleep(2))

		-- Close all Warp windows
		await(closeAllWarpWindows_async())
		await(promise.sleep(1))

		-- Move chats back to main screen
		await(portChats.moveChatsBack())
		await(promise.sleep(1))

		-- Resume handler before tidy (tidyAllScreens_async has its own pause/resume)
		windowManager.resumeHandler()

		-- Tidy all screens
		await(windowManager.tidyAllScreens_async())
		await(promise.sleep(0.4))

		-- Move mouse to center of primary screen
		centerMouse()
		await(promise.sleep(0.4))

		logger.success("Setup complete")

		hs.execute("open -g raycast://extensions/raycast/raycast/confetti")
		await(promise.sleep(0.2))
		hs.execute("open -g raycast://extensions/raycast/raycast/confetti")
		await(promise.sleep(0.2))
		hs.execute("open -g raycast://extensions/raycast/raycast/confetti")
	end):catch(function(err)
		logger.error("Setup failed:", tostring(err))
		raycastNotification.showHUD("⚠️ Setup failed: " .. tostring(err))
		-- Ensure handler is resumed even on error
		windowManager.resumeHandler()
	end)
end

return setup
