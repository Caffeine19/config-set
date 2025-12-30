-- Utility functions for Hammerspoon
local utils = {}

-- Function to merge arrays
-- Similar to JS [...array]
function utils.merge(...)
    local result = {}
    for _, array in ipairs({ ... }) do
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

-- Map function similar to JS array.map
-- Applies a function to each element and returns a new array
function utils.map(array, func)
    local result = {}
    for i, value in ipairs(array) do
        result[i] = func(value, i, array)
    end
    return result
end

-- ForEach function similar to JS array.forEach
-- Executes a function for each element (no return value)
function utils.forEach(array, func)
    for i, value in ipairs(array) do
        func(value, i, array)
    end
end

-- Filter function similar to JS array.filter
-- Returns a new array with elements that pass the test
function utils.filter(array, predicate)
    local result = {}
    for i, value in ipairs(array) do
        if predicate(value, i, array) then
            table.insert(result, value)
        end
    end
    return result
end

-- Find function similar to JS array.find
-- Returns the first element that satisfies the predicate
function utils.find(array, predicate)
    for i, value in ipairs(array) do
        if predicate(value, i, array) then
            return value
        end
    end
    return nil
end

-- Reduce function similar to JS array.reduce
-- Applies a reducer function against an accumulator
function utils.reduce(array, reducer, initialValue)
    local accumulator = initialValue
    local startIndex = 1

    -- If no initial value, use first element as accumulator
    if accumulator == nil then
        accumulator = array[1]
        startIndex = 2
    end

    for i = startIndex, #array do
        accumulator = reducer(accumulator, array[i], i, array)
    end

    return accumulator
end

-- Flat function similar to JS array.flat()
-- Flattens nested arrays to specified depth (default depth = 1)
function utils.flat(array, depth)
    depth = depth or 1
    local result = {}

    local function flattenHelper(arr, currentDepth)
        for _, value in ipairs(arr) do
            if type(value) == "table" and currentDepth > 0 then
                flattenHelper(value, currentDepth - 1)
            else
                table.insert(result, value)
            end
        end
    end

    flattenHelper(array, depth)
    return result
end

-- FlatMap function similar to JS array.flatMap()
-- Maps each element using a mapping function, then flattens the result
function utils.flatMap(array, func)
    local mapped = utils.map(array, func)
    return utils.flat(mapped, 1)
end

function utils.forEachEntries(object, func)
    for k, v in pairs(object) do
        func(k, v)
    end
end

return utils
