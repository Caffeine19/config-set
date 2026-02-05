-- ms.lua: Lua implementation of the npm ms package
-- Converts various time formats to microseconds for use with hs.timer.usleep

local ms = {}

-- Time unit mappings to microseconds
local units = {
	-- Milliseconds
	["ms"] = 1000,
	["millisecond"] = 1000,
	["milliseconds"] = 1000,

	-- Seconds
	["s"] = 1000000,
	["sec"] = 1000000,
	["secs"] = 1000000,
	["second"] = 1000000,
	["seconds"] = 1000000,

	-- Minutes
	["m"] = 60000000,
	["min"] = 60000000,
	["mins"] = 60000000,
	["minute"] = 60000000,
	["minutes"] = 60000000,

	-- Hours
	["h"] = 3600000000,
	["hr"] = 3600000000,
	["hrs"] = 3600000000,
	["hour"] = 3600000000,
	["hours"] = 3600000000,

	-- Days
	["d"] = 86400000000,
	["day"] = 86400000000,
	["days"] = 86400000000,

	-- Weeks
	["w"] = 604800000000,
	["week"] = 604800000000,
	["weeks"] = 604800000000,

	-- Years (365.25 days)
	["y"] = 31557600000000,
	["yr"] = 31557600000000,
	["yrs"] = 31557600000000,
	["year"] = 31557600000000,
	["years"] = 31557600000000,
}

-- Main function to convert time string to microseconds
function ms.ms(value)
	if type(value) == "number" then
		return value
	end

	if type(value) ~= "string" then
		return nil
	end

	-- Remove whitespace
	value = value:gsub("%s+", "")

	-- If it's just a number, return it as is
	local num = tonumber(value)
	if num then
		return num
	end

	-- Parse number and unit from string
	local number, unit = value:match("^([%-%+]?%d*%.?%d+)([a-zA-Z]+)$")

	if not number or not unit then
		return nil
	end

	number = tonumber(number)
	if not number then
		return nil
	end

	-- Look up unit multiplier
	local multiplier = units[unit:lower()]
	if not multiplier then
		return nil
	end

	return math.floor(number * multiplier)
end

return ms
