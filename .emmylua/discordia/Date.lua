---@alias Timestamp string

---@class Date

local Date = {
    -- [[Date Methods]] --

    ---Returns an RFC 2822 string that represents the stored date and time.
    ---@param self Date
    ---@return string
    toHeader = function(self) end,

    ---Retuns an ISO 8601 timestamp that reperesents the stored date and time.
    ---If `sep` and `tz` are both provided, then they are used as a custom seperator and timezone.
    ---Otherwise, `T` is used as the seperator and `+00:00` is used for the timezone, plus microseconds if available.
    ---@param self Date
    ---@param sep string
    ---@param tz string
    ---@return Timestamp
    toISO = function(self, sep, tz) end,

    ---Returns a Unix time in microseconds that represents the stored date and time.
    ---@param self Date
    ---@return number
    toMicroseconds = function(self) end,

    ---Returns a Unix time in milliseconds that represents the stored date and time.
    ---@param self Date
    ---@return number
    toMilliseconds = function(self) end,

    ---Returns the seconds and microseconds that are stored in the date object.
    ---@param self Date
    ---@return number
    ---@return number
    toParts = function(self) end,

    ---Returns a Unix time in seconds that represents the stored date and  time.
    ---@param self Date
    ---@return number
    toSeconds = function(self) end,

    ---Returns a Discord Snowflake ID based on the stored date and time.
    ---Note that `Date.fromSnowflake(id):toSnowflake() == id` may be false.
    ---@param self Date
    ---@return SnowflakeId
    toSnowflake = function(self) end,

    ---Returns a string that represents this Date object formatted via Lua's `os.date`.
    ---If no format string is provided, the default is `%a %b %d %Y %T GMT%z (%Z)`.
    ---@param self Date
    ---@param fmt string
    ---@return string
    toString = function(self, fmt) end,

    ---Returns a Lua date table that represents the stored time and date as the local time.
    ---Equivalent to `os.date("*t", Date:toSeconds())`.
    ---@param self Date
    ---@return Date
    toTable = function(self) end,

    ---Returns a Lua date table that represents the stored time and date as a UTC time.
    ---Equivalent to `os.date("!*t", Date:toSeconds())`.
    ---@param self Date
    ---@return Date
    toTableUTC = function(self) end,

    -- [[Date Static Functions]] --

    ---Constructs a new Date object from an RFC 2822 string.
    ---Equivalent to `Date.fromSeconds(Date.parseHeader(str))`
    ---@param str string
    ---@return Date
    fromHeader = function(str) end,

    ---Constructs a new Date object from an ISO 8601 string.
    ---Equivalent to `Date.fromSeconds(Date.parseISO(str))`
    ---@param str Timestamp
    ---@return Date
    fromISO = function(str) end,

    ---Constructs a new Date object from a Unix time in microseconds.
    ---@param us number
    ---@return Date
    fromMicroseconds = function(us) end,

    ---Constructs a new Date object from a Unix time in milliseconds.
    ---@param ms number
    ---@return Date
    fromMilliseconds = function(ms) end,

    ---Constructs a new Date object from a Unix time in seconds.
    ---@param s number
    ---@return Date
    fromSeconds = function(s) end,

    ---Constructs a new Date object from a Discord Snowflake ID.
    ---Equivalent to `Date.fromSeconds(Date.parseSnowflake(id))`
    ---@param id SnowflakeId
    ---@return Date
    fromSnowflake = function(id) end,

    ---Constructs a new Date object from a Lua date table interpreted as a local time.
    ---Equivalent to `Date.fromSeconds(Date.parseTable(tbl))`.
    ---@param tbl table
    ---@return Date
    fromTable = function(tbl) end,

    ---Constructs a new Date object from a Lua date table interpreted as a UTC time.
    ---Equivalent to `Date.fromSeconds(Date.parseTableUTC(tbl))`.
    ---@param tbl table
    ---@return Date
    fromTableUTC = function(tbl) end,

    ---Converts an RFC 2822 string into a Unix time in seconds.
    ---@param str string
    ---@return number
    parseHeader = function(str) end,

    ---Converts an ISO 8601 string into a Unix time in seconds.
    ---For compatibility with Discord's timestamp format, microseconds are also provided as a second return value.
    ---@param str Timestamp
    ---@return number
    ---@return number
    parseISO = function(str) end,

    ---Converts a Discord Snowflake ID into a Unix time in seconds.
    ---Additional decimal points may be present, though only the first 3 should be considered accurate.
    ---@param id SnowflakeId
    ---@return number
    parseSnowflake = function(id) end,

    ---Interprets a Lua date table as a local time and converts it to a Unix time in seconds.
    ---Equivalent to `os.time(tbl)`.
    ---@param tbl table
    ---@return number
    parseTable = function(tbl) end,

    ---Interprets a Lua date table as a UTC time and converts it to a Unix time in seconds.
    ---Equivalent to `os.time(tbl)` with a correction for UTC.
    ---@param tbl table
    ---@return number
    parseTableUTC = function(tbl) end,
}

return Date