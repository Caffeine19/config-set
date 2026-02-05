local console = {}

function console.init()
	-- Default: 10000
	hs.console.maxOutputHistory(100000000)
	hs.console.darkMode(true)

	hs.console.consoleCommandColor({
		red = 0.667,
		green = 0.627,
		blue = 0.98,
		alpha = 1.0,
	})

	-- hs.console.outputBackgroundColor({ red = 0.1, green = 0.1, blue = 0.1, alpha = 1 })

	-- jetbrains fleet theme entity.other.attribute-name
	-- purple
	-- rgba(66.7%, 62.7%, 98%, 1)
	hs.console.consolePrintColor({
		red = 0.667,
		green = 0.627,
		blue = 0.98,
		alpha = 1.0,
	})

	-- jetbrains fleet theme constant.other.symbol
	-- white
	-- rgba(83.9%, 83.9%, 86.7%, 1)
	-- hs.console.consolePrintColor({ red = 0.839, green = 0.839, blue = 0.867, alpha = 1.0 })

	-- hs.console.consoleFont({ name = "JetBrainsMono Nerd Font Propo", size = 14 })
	hs.console.consoleFont({ name = "Maple Mono", size = 14 })
end

return console
