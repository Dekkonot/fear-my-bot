---@alias SnowflakeId string

---@class Snowflake
---@field client Client
---@field parent Container|Client
---@field createdAt number
---@field id SnowflakeId
---@field timestamp string

local Snowflake = {
    -- [[Snowflake Methods]] --

    ---Returns `Snowflake.id`
    ---@param self Snowflake
    ---@return SnowflakeId
    __hash = function(self) end,

    ---Returns a unique `Date` object that represents when this object was created by Discord.
    ---Equivalent to `Date.fromSnowflake(Snowflake.id)`
    ---@param self Snowflake
    ---@return Date
    getDate = function(self) end,
}

return Snowflake