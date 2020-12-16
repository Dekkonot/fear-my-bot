---@class Stopwatch
---@field milliseconds number

local Stopwatch = {
    -- [[Stopwatch Methods]] --

    ---Returns a new Time object that represents the currently elapsed time.
    ---This is useful for 'catching' the current time and comparing its many forms as required.
    ---@param self Stopwatch
    ---@return Time
    getTime = function(self) end,

    ---Effectively resets the stopwatch.
    ---@param self Stopwatch
    reset = function(self) end,

    ---Effectively starts the stopwatch.
    ---@param self Stopwatch
    start = function(self) end,

    ---Effectively stops the stopwatch.
    ---@param self Stopwatch
    stop = function(self) end,
}

return Stopwatch