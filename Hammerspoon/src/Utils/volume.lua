-- Volume utility: convert grid-based volume steps to percentage
-- macOS volume control has 16 steps total

local volume = {}

local GRID_STEPS = 16

--- Convert a grid step number to a volume percentage.
--- @param step number  1–16 grid position (matches macOS volume steps)
--- @return number      volume percentage (0–100)
function volume.grid(step)
	return (step / GRID_STEPS) * 100
end

return volume
