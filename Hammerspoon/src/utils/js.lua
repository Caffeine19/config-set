-- Utility functions for Hammerspoon
-- JavaScript-style array/object helpers for Lua tables
local js = {}

--- Merge multiple arrays into a single array.
--- Similar to JS `[...arr1, ...arr2]`
---@param ... any[] Arrays to merge
---@return any[]
function js.merge(...)
	local result = {}
	for _, array in ipairs({ ... }) do
		for _, value in ipairs(array) do
			table.insert(result, value)
		end
	end
	return result
end

--- Check if an array contains a value.
--- Similar to JS `array.includes(value)`
---@generic T
---@param table T[] The array to search
---@param value T The value to find
---@return boolean
function js.includes(table, value)
	for _, v in ipairs(table) do
		if v == value then
			return true
		end
	end
	return false
end

--- Apply a function to each element and return a new array.
--- Similar to JS `array.map(fn)`
---@generic T, U
---@param array T[] The source array
---@param func fun(value: T, index: integer, array: T[]): U The mapping function
---@return U[]
function js.map(array, func)
	local result = {}
	for i, value in ipairs(array) do
		result[i] = func(value, i, array)
	end
	return result
end

--- Execute a function for each element (no return value).
--- Similar to JS `array.forEach(fn)`
---@generic T
---@param array T[] The source array
---@param func fun(value: T, index: integer, array: T[]) The callback function
function js.forEach(array, func)
	for i, value in ipairs(array) do
		func(value, i, array)
	end
end

--- Return a new array with elements that pass the predicate.
--- Similar to JS `array.filter(fn)`
--- Note: Uses pairs to handle sparse arrays (ipairs stops at first nil)
---@generic T
---@param array T[] The source array
---@param predicate fun(value: T, index: integer, array: T[]): boolean The test function
---@return T[]
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

--- Return the first element that satisfies the predicate, or nil.
--- Similar to JS `array.find(fn)`
---@generic T
---@param array T[] The source array
---@param predicate fun(value: T, index: integer, array: T[]): boolean The test function
---@return T|nil
function js.find(array, predicate)
	for i, value in ipairs(array) do
		if predicate(value, i, array) then
			return value
		end
	end
	return nil
end

--- Apply a reducer function against an accumulator.
--- Similar to JS `array.reduce(fn, init)`
---@generic T, U
---@param array T[] The source array
---@param reducer fun(accumulator: U, value: T, index: integer, array: T[]): U The reducer function
---@param initialValue? U The initial accumulator value (defaults to first element)
---@return U
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

--- Flatten nested arrays to a specified depth.
--- Similar to JS `array.flat(depth)`
---@param array any[] The source array (possibly nested)
---@param depth? integer Flatten depth (default 1)
---@return any[]
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

--- Map each element then flatten the result by one level.
--- Similar to JS `array.flatMap(fn)`
---@generic T, U
---@param array T[] The source array
---@param func fun(value: T, index: integer, array: T[]): U[] The mapping function (should return arrays)
---@return U[]
function js.flatMap(array, func)
	local mapped = js.map(array, func)
	return js.flat(mapped, 1)
end

--- Iterate over key-value pairs of an object/table.
--- Similar to JS `Object.entries(obj).forEach(([k, v]) => fn(k, v))`
---@generic K, V
---@param object table<K, V> The source table
---@param func fun(key: K, value: V) The callback function
function js.forEachEntries(object, func)
	for k, v in pairs(object) do
		func(k, v)
	end
end

--- Return an array of the table's values.
--- Similar to JS `Object.values(obj)`
---@generic V
---@param object table<any, V> The source table
---@return V[]
function js.values(object)
	local result = {}
	for _, v in pairs(object) do
		table.insert(result, v)
	end
	return result
end

--- Return elements in the first array that are not in the second.
--- Similar to radash `diff()`
---@generic T
---@param array T[] The source array
---@param other T[] The array to exclude
---@return T[]
function js.diff(array, other)
	return js.filter(array, function(value)
		return not js.includes(other, value)
	end)
end

--- Async version of forEach that works with await.
--- Must be called within an async context.
--- Usage: `await(forEachAsync(array, function(value) await(asyncOp()) end))`
---@generic T
---@param array T[] The source array
---@param func fun(value: T, index: integer, array: T[]) The async callback function
---@return table Promise
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

--- Async version of map that works with await.
--- Must be called within an async context.
--- Usage: `local results = await(mapAsync(array, function(value) return await(asyncOp()) end))`
---@generic T, U
---@param array T[] The source array
---@param func fun(value: T, index: integer, array: T[]): U The async mapping function
---@return table Promise
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
