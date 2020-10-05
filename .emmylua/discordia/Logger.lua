---@class Logger

local Logger = {
    -- [[Logger Methods]] --

    ---If the provided level is less than or equal to the log level set on initialization,
    ---this logs a message to `stdout` and to a file if one was provided on initialization.
    ---`msg` is formatted according to `string.format(msg, ...)` and is returned if the message is logged.
    ---@param self Logger
    ---@param level enums.logLevel
    ---@param msg string
    ---@return string
    log = function(self, level, msg, ...) end,
}

return Logger