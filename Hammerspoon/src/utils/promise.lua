-- promise.lua: Promise + Async/Await implementation for Hammerspoon using coroutines
-- Provides a clean async/await pattern for asynchronous programming
--
-- Usage:
--   local promise = require("utils.promise")
--   local async, await = promise.async, promise.await
--
--   async(function()
--       await(promise.sleep(1))
--       print("1 second later")
--   end)

local promise = {}

---@class Promise
---@field _status "pending" | "fulfilled" | "rejected"
---@field _value any
---@field _callbacks table
local Promise = {}
Promise.__index = Promise

-- Create a new Promise
---@param executor fun(resolve: fun(value: any), reject: fun(reason: any))
---@return Promise
function Promise.new(executor)
	local self = setmetatable({}, Promise)
	self._status = "pending"
	self._value = nil
	self._callbacks = { onFulfilled = {}, onRejected = {} }

	local function resolve(value)
		if self._status ~= "pending" then
			return
		end
		self._status = "fulfilled"
		self._value = value
		for _, callback in ipairs(self._callbacks.onFulfilled) do
			callback(value)
		end
	end

	local function reject(reason)
		if self._status ~= "pending" then
			return
		end
		self._status = "rejected"
		self._value = reason
		for _, callback in ipairs(self._callbacks.onRejected) do
			callback(reason)
		end
	end

	-- Execute the executor function
	local ok, err = pcall(executor, resolve, reject)
	if not ok then
		reject(err)
	end

	return self
end

-- Chain a callback to be executed when the promise is fulfilled
---@param onFulfilled? fun(value: any): any
---@param onRejected? fun(reason: any): any
---@return Promise
function Promise:andThen(onFulfilled, onRejected)
	return Promise.new(function(resolve, reject)
		local function handleFulfilled(value)
			if onFulfilled then
				local ok, result = pcall(onFulfilled, value)
				if ok then
					if type(result) == "table" and result.andThen then
						result:andThen(resolve, reject)
					else
						resolve(result)
					end
				else
					reject(result)
				end
			else
				resolve(value)
			end
		end

		local function handleRejected(reason)
			if onRejected then
				local ok, result = pcall(onRejected, reason)
				if ok then
					if type(result) == "table" and result.andThen then
						result:andThen(resolve, reject)
					else
						resolve(result)
					end
				else
					reject(result)
				end
			else
				reject(reason)
			end
		end

		if self._status == "fulfilled" then
			hs.timer.doAfter(0, function()
				handleFulfilled(self._value)
			end)
		elseif self._status == "rejected" then
			hs.timer.doAfter(0, function()
				handleRejected(self._value)
			end)
		else
			table.insert(self._callbacks.onFulfilled, handleFulfilled)
			table.insert(self._callbacks.onRejected, handleRejected)
		end
	end)
end

-- Catch rejected promises
---@param onRejected fun(reason: any): any
---@return Promise
function Promise:catch(onRejected)
	return self:andThen(nil, onRejected)
end

-- Finally handler
---@param onFinally fun()
---@return Promise
function Promise:finally(onFinally)
	return self:andThen(function(value)
		onFinally()
		return value
	end, function(reason)
		onFinally()
		error(reason)
	end)
end

-- Create a resolved promise
---@param value any
---@return Promise
function Promise.resolve(value)
	if type(value) == "table" and value.andThen then
		return value
	end
	return Promise.new(function(resolve)
		resolve(value)
	end)
end

-- Create a rejected promise
---@param reason any
---@return Promise
function Promise.reject(reason)
	return Promise.new(function(_, reject)
		reject(reason)
	end)
end

-- Wait for all promises to resolve
---@param promises Promise[]
---@return Promise
function Promise.all(promises)
	return Promise.new(function(resolve, reject)
		local results = {}
		local remaining = #promises

		if remaining == 0 then
			resolve(results)
			return
		end

		for i, promise in ipairs(promises) do
			Promise.resolve(promise):andThen(function(value)
				results[i] = value
				remaining = remaining - 1
				if remaining == 0 then
					resolve(results)
				end
			end, reject)
		end
	end)
end

-- Wait for the first promise to resolve or reject
---@param promises Promise[]
---@return Promise
function Promise.race(promises)
	return Promise.new(function(resolve, reject)
		for _, promise in ipairs(promises) do
			Promise.resolve(promise):andThen(resolve, reject)
		end
	end)
end

-- Wait for all promises to settle (resolve or reject)
---@param promises Promise[]
---@return Promise
function Promise.allSettled(promises)
	return Promise.new(function(resolve)
		local results = {}
		local remaining = #promises

		if remaining == 0 then
			resolve(results)
			return
		end

		for i, promise in ipairs(promises) do
			Promise.resolve(promise):andThen(function(value)
				results[i] = { status = "fulfilled", value = value }
				remaining = remaining - 1
				if remaining == 0 then
					resolve(results)
				end
			end, function(reason)
				results[i] = { status = "rejected", reason = reason }
				remaining = remaining - 1
				if remaining == 0 then
					resolve(results)
				end
			end)
		end
	end)
end

-- Export Promise class
promise.Promise = Promise

-----------------------------------------------------------
-- Async/Await Implementation using Coroutines
-----------------------------------------------------------

-- Run an async function
-- Usage:
--   local async, await = promise.async, promise.await
--   async(function() local data = await(fetchData()) end)
---@param fn fun(): any
---@return Promise
function promise.async(fn)
	return Promise.new(function(resolve, reject)
		local co = coroutine.create(fn)

		local function step(...)
			local ok, result = coroutine.resume(co, ...)
			if not ok then
				reject(result)
				return
			end

			if coroutine.status(co) == "dead" then
				resolve(result)
				return
			end

			-- If result is a promise, wait for it
			if type(result) == "table" and result.andThen then
				result:andThen(function(value)
					step(value)
				end, function(reason)
					-- Resume with error
					local errOk, errResult = coroutine.resume(co, nil, reason)
					if not errOk or coroutine.status(co) == "dead" then
						reject(reason)
					end
				end)
			else
				-- Continue immediately if not a promise
				step(result)
			end
		end

		step()
	end)
end

-- Await a promise (must be called inside promise.async)
-- Usage: local result = await(somePromise)
---@param p Promise | any
---@return any
function promise.await(p)
	if type(p) ~= "table" or not p.andThen then
		return p
	end
	local result, err = coroutine.yield(p)
	if err then
		error(err)
	end
	return result
end

-----------------------------------------------------------
-- Utility Functions
-----------------------------------------------------------

-- Sleep for a specified duration (returns a promise)
---@param seconds number Duration in seconds
---@return Promise
function promise.sleep(seconds)
	return Promise.new(function(resolve)
		hs.timer.doAfter(seconds, function()
			resolve(true)
		end)
	end)
end

-- Sleep for a specified duration in milliseconds
---@param milliseconds number Duration in milliseconds
---@return Promise
function promise.sleepMs(milliseconds)
	return promise.sleep(milliseconds / 1000)
end

-- Wrap a callback-style function into a promise
-- Usage: promise.promisify(function(callback) ... callback(result) end)
---@param fn fun(callback: fun(result: any, err: any))
---@return Promise
function promise.promisify(fn)
	return Promise.new(function(resolve, reject)
		fn(function(result, err)
			if err then
				reject(err)
			else
				resolve(result)
			end
		end)
	end)
end

return promise
