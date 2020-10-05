---@class Emoji

-- [[Container Fields]] --

---@field client Client
---@field parent Container|Client

-- [[Snowflake Fields]] --

---@field createdAt number
---@field id SnowflakeId
---@field timestamp string

-- [[Emoji Fields]] --

---@field animated boolean
---@field guild Guild
---@field hash string
---@field managed boolean
---@field mentionString string
---@field name string
---@field requireColons boolean
---@field roles ArrayIterable
---@field url string

local Emoji = {
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

    -- [[Emoji Methods]] --

    ---Permanently deletes the emoji.
    ---@param self Emoji
    ---@return boolean
    delete = function(self) end,

    ---Returns whether or not the provided role is allowed to use the emoji.
    ---@param self Emoji
    ---@param id SnowflakeId
    ---@return boolean
    hasRole = function(self, id) end,

    ---Sets the emoji's name. The name must be between 2 and 32 characters in length.
    ---@param self Emoji
    ---@param name string
    ---@return boolean
    setName = function(self, name) end,

    ---Sets the roles that can use the emoji.
    ---@param self Emoji
    ---@param roles Role[]
    ---@return boolean
    setRoles = function(self, roles) end,
}

return Emoji