local js = require("Utils.js")

local notion = {}

function notion.init()
	local function isNotionVisible()
		local notionApp = hs.application.find("notion.id") -- 替换为实际 bundle id
		if notionApp then
			local wins = notionApp:allWindows()
			for _, w in ipairs(wins) do
				if w:isVisible() then
					return true
				end
			end
		end
		return false
	end

	local function updateKarabinerVar()
		local val = isNotionVisible() and 1 or 0
		hs.execute(
			string.format(
				"'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --set-variable notion_active %d",
				val
			)
		)
	end

	-- 监听窗口焦点变化
	hs.window.filter.new():subscribe({
		hs.window.filter.windowFocused,
		hs.window.filter.windowVisible,
		hs.window.filter.windowHidden,
		hs.window.filter.windowDestroyed,
	}, updateKarabinerVar)
end

return notion
