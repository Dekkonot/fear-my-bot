---@class Time

local Time = {
    -- [[Time Methods]] --

    ---Returns the total number of days that the time object represents.
    ---@param self Time
    ---@return number
    toDays = function(self) end,

    ---Returns the total number of hours that the time object represents.
    ---@param self Time
    ---@return number
    toHours = function(self) end,

    ---Returns the total number of milliseconds that the time object represents.
    ---@param self Time
    ---@return number
    toMilliseconds = function(self) end,

    ---Returns the total number of minutes that the time object represents.
    ---@param self Time
    ---@return number
    toMinutes = function(self) end,

    ---Returns the total number of seconds that the time object represents.
    ---@param self Time
    ---@return number
    toSeconds = function(self) end,

    ---Returns a human-readable string built from the set of normalized time values that the object represents.
    ---@param self Time
    ---@return string
    toString = function(self) end,

    ---Returns a table of normalized time values that represent the time object in a more accessible form.
    ---This table is **not** compatible with `os.date`.
    ---@param self Time
    ---@return table
    toTable = function(self) end,

    ---Returns the total number of weeks that the time object represents.
    ---@param self Time
    ---@return number
    toWeeks = function(self) end,
}

return Time