-- Utility functions for Hammerspoon
local utils = {}

-- Function to merge arrays
-- Similar to JS [...array]
function utils.mergeArrays(...)
    local result = {}
    for _, array in ipairs({...}) do
        for _, value in ipairs(array) do
            table.insert(result, value)
        end
    end
    return result
end

-- Generic includes function
-- Similar to JS array.includes
function utils.includes(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

return utils
