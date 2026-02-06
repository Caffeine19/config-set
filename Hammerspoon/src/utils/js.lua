-- Utility functions for Hammerspoon
local js = {}

-- Function to merge arrays
-- Similar to JS [...array]
function js.merge(...)
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
function js.includes(table, value)
	for _, v in ipairs(table) do
		if v == value then
			return true
		end
	end
	return false
end

-- Map function similar to JS array.map
-- Applies a function to each element and returns a new array
function js.map(array, func)
	local result = {}
	for i, value in ipairs(array) do
		result[i] = func(value, i, array)
	end
	return result
end

-- ForEach function similar to JS array.forEach
-- Executes a function for each element (no return value)
function js.forEach(array, func)
	for i, value in ipairs(array) do
		func(value, i, array)
	end
end

-- Filter function similar to JS array.filter
-- Returns a new array with elements that pass the test
-- Note: Uses pairs to handle sparse arrays (ipairs stops at first nil)
function js.filter(array, predicate)
	local result = {}

	-- Collect and sort numeric indices to handle sparse arrays while preserving order
	local indices = {}
	for i, _ in pairs(array) do
		if type(i) == "number" then
			table.insert(indices, i)
		end
	end
	table.sort(indices)

	-- Filter in sorted order
	for _, i in ipairs(indices) do
		local value = array[i]
		if predicate(value, i, array) then
			table.insert(result, value)
		end
	end

	return result
end

-- Find function similar to JS array.find
-- Returns the first element that satisfies the predicate
function js.find(array, predicate)
	for i, value in ipairs(array) do
		if predicate(value, i, array) then
			return value
		end
	end
	return nil
end

-- Reduce function similar to JS array.reduce
-- Applies a reducer function against an accumulator
function js.reduce(array, reducer, initialValue)
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
function js.flat(array, depth)
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
function js.flatMap(array, func)
	local mapped = js.map(array, func)
	return js.flat(mapped, 1)
end

function js.forEachEntries(object, func)
	for k, v in pairs(object) do
		func(k, v)
	end
end

-- Values function similar to JS Object.values()
-- Returns an array of the object's values
function js.values(object)
	local result = {}
	for _, v in pairs(object) do
		table.insert(result, v)
	end
	return result
end

-- Diff function similar to radash diff()
-- Returns elements in first array that are not in second array
function js.diff(array, other)
	return js.filter(array, function(value)
		return not js.includes(other, value)
	end)
end

-- Async version of forEach that works with await
-- Usage: await(js.forEachAsync(array, function(value) await(asyncOp()) end))
-- Note: Requires promise module and must be called within async context
function js.forEachAsync(array, func)
	local promise = require("utils.promise")
	return promise.async(function()
		for i, value in ipairs(array) do
			promise.await(promise.async(function()
				func(value, i, array)
			end))
		end
	end)
end

-- Async version of map that works with await
-- Usage: local results = await(js.mapAsync(array, function(value) return await(asyncOp()) end))
function js.mapAsync(array, func)
	local promise = require("utils.promise")
	return promise.async(function()
		local result = {}
		for i, value in ipairs(array) do
			result[i] = promise.await(promise.async(function()
				return func(value, i, array)
			end))
		end
		return result
	end)
end

return js
