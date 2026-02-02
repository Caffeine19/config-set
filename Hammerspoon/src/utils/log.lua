-- Log Module for Hammerspoon
-- Provides unified logging with emoji prefixes and consistent formatting

local log = {}

-- Log levels configuration
log.LEVELS = {
    DEBUG = 1,
    INFO = 2,
    ERROR = 3,
    SUCCESS = 4,
}

-- Emoji mappings for each log level
local LEVEL_EMOJIS = {
    DEBUG = "🔍",
    INFO = "📌",
    ERROR = "⚠️",
    SUCCESS = "🍀",
}

-- Custom emoji overrides for common actions
log.EMOJI = {
    -- Status
    SUCCESS = "🍀",
    ERROR = "⚠️",
    CELEBRATE = "🎉",

    -- Actions
    START = "🚀",
    STOP = "🛑",
    LAUNCH = "📱",
    WAIT = "⏰",
    SEARCH = "🔍",
    CLICK = "🖱️",
    TYPE = "⌨️",
    LINK = "🔗",
    TARGET = "🎯",
    QUIT = "🚪",
    IMAGE = "🖼️",
    BUTTON = "🔘",

    -- Sound/Media
    SOUND = "🔊",
    MUTE = "🔇",
}

-- Current log level (messages below this level will be filtered)
log.currentLevel = log.LEVELS.DEBUG

-- Enable/disable logging
log.enabled = true

-- Helper: Convert value to string for logging
local function stringify(value)
    if value == nil then
        return "nil"
    elseif type(value) == "string" then
        return value
    elseif type(value) == "table" or type(value) == "userdata" then
        return hs.inspect(value)
    else
        return tostring(value)
    end
end

-- Helper: Format multiple arguments into a single string
local function formatArgs(...)
    local args = { ... }
    local parts = {}

    for i, arg in ipairs(args) do
        table.insert(parts, stringify(arg))
    end

    return table.concat(parts, " ")
end

-- Helper: Format log message with module tag
local function formatMessage(emoji, module, ...)
    local message = formatArgs(...)

    if module and module ~= "" then
        return string.format("%s [%s] %s", emoji, string.upper(module), message)
    else
        return string.format("%s %s", emoji, message)
    end
end

-- Core logging function
local function logWithLevel(level, emoji, module, ...)
    if not log.enabled then
        return
    end

    if log.LEVELS[level] < log.currentLevel then
        return
    end

    local finalEmoji = emoji or LEVEL_EMOJIS[level]
    print(formatMessage(finalEmoji, module, ...) .. "\n")
end

-----------------------------------------------------------
-- Public API: Standard log levels
-----------------------------------------------------------

--- Log a debug message (verbose, for development)
-- @param module string Module/feature name (e.g., "ENDEL", "FOCUS")
-- @param ... any Values to log (will be converted to strings)
function log.debug(module, ...)
    logWithLevel("DEBUG", LEVEL_EMOJIS.DEBUG, module, ...)
end

--- Log an info message (general information)
-- @param module string Module/feature name
-- @param ... any Values to log
function log.info(module, ...)
    logWithLevel("INFO", LEVEL_EMOJIS.INFO, module, ...)
end

--- Log an error/warning message
-- @param module string Module/feature name
-- @param ... any Values to log
function log.error(module, ...)
    logWithLevel("ERROR", LEVEL_EMOJIS.ERROR, module, ...)
end

-- Alias for error (backward compatibility)
log.warn = log.error

--- Log a success message
-- @param module string Module/feature name
-- @param ... any Values to log
function log.success(module, ...)
    logWithLevel("SUCCESS", LEVEL_EMOJIS.SUCCESS, module, ...)
end

-----------------------------------------------------------
-- Public API: Custom emoji logging
-----------------------------------------------------------

--- Log with a custom emoji prefix
-- @param emoji string Custom emoji to use
-- @param module string Module/feature name
-- @param ... any Values to log
function log.custom(emoji, module, ...)
    if not log.enabled then
        return
    end
    print(formatMessage(emoji, module, ...) .. "\n")
end

-----------------------------------------------------------
-- Public API: Action-specific logging (with semantic emojis)
-----------------------------------------------------------

--- Log a start/launch action
function log.start(module, ...)
    log.custom(log.EMOJI.START, module, ...)
end

--- Log an app launch
function log.launch(module, ...)
    log.custom(log.EMOJI.LAUNCH, module, ...)
end

--- Log a wait/delay
function log.wait(module, ...)
    log.custom(log.EMOJI.WAIT, module, ...)
end

--- Log a search action
function log.search(module, ...)
    log.custom(log.EMOJI.SEARCH, module, ...)
end

--- Log a click action
function log.click(module, ...)
    log.custom(log.EMOJI.CLICK, module, ...)
end

--- Log a typing action
function log.type(module, ...)
    log.custom(log.EMOJI.TYPE, module, ...)
end

--- Log a link/connection action
function log.link(module, ...)
    log.custom(log.EMOJI.LINK, module, ...)
end

--- Log a target/focus action
function log.target(module, ...)
    log.custom(log.EMOJI.TARGET, module, ...)
end

--- Log a celebration/completion
function log.celebrate(module, ...)
    log.custom(log.EMOJI.CELEBRATE, module, ...)
end

--- Log a button action
function log.button(module, ...)
    log.custom(log.EMOJI.BUTTON, module, ...)
end

--- Log an image-related action
function log.image(module, ...)
    log.custom(log.EMOJI.IMAGE, module, ...)
end

--- Log a quit/close action
function log.quit(module, ...)
    log.custom(log.EMOJI.QUIT, module, ...)
end

-----------------------------------------------------------
-- Public API: Utility functions
-----------------------------------------------------------

--- Create a logger scoped to a specific module
-- @param moduleName string The module name to use for all logs
-- @return table Logger with all methods pre-scoped to the module
function log.createLogger(moduleName)
    local logger = {}

    logger.debug = function(...) log.debug(moduleName, ...) end
    logger.info = function(...) log.info(moduleName, ...) end
    logger.error = function(...) log.error(moduleName, ...) end
    logger.warn = logger.error -- Alias
    logger.success = function(...) log.success(moduleName, ...) end

    logger.start = function(...) log.start(moduleName, ...) end
    logger.launch = function(...) log.launch(moduleName, ...) end
    logger.wait = function(...) log.wait(moduleName, ...) end
    logger.search = function(...) log.search(moduleName, ...) end
    logger.click = function(...) log.click(moduleName, ...) end
    logger.type = function(...) log.type(moduleName, ...) end
    logger.link = function(...) log.link(moduleName, ...) end
    logger.target = function(...) log.target(moduleName, ...) end
    logger.celebrate = function(...) log.celebrate(moduleName, ...) end
    logger.button = function(...) log.button(moduleName, ...) end
    logger.image = function(...) log.image(moduleName, ...) end
    logger.quit = function(...) log.quit(moduleName, ...) end

    logger.custom = function(emoji, ...) log.custom(emoji, moduleName, ...) end

    return logger
end

--- Set the minimum log level
-- @param level number One of log.LEVELS values
function log.setLevel(level)
    log.currentLevel = level
end

--- Enable or disable all logging
-- @param enabled boolean
function log.setEnabled(enabled)
    log.enabled = enabled
end

return log
