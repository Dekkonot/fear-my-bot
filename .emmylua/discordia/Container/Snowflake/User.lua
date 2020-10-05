---@class User

-- [[Container Fields]] --

---@field client Client
---@field parent Container|Client

-- [[Snowflake Fields]] --

---@field createdAt number
---@field id SnowflakeId
---@field timestamp string

-- [[User Fields]] --

---@field avatar string|nil
---@field avatarURL string
---@field bot boolean
---@field defaultAvatar enums.defaultAvatar
---@field defaultAvatarURL string
---@field discriminator number
---@field mentionString string
---@field mutualGuilds FilteredIterable
---@field name string
---@field tag string
---@field username string

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

    -- [[User Methods]] --

    ---Returns a URL that can be used to view the user's full avatar, or its default avatar if it doesn't have one. If provided, `size` must be a power of 2.
    ---If `extension` is provided, it must be a valid image format.
    ---@param self User
    ---@param size number
    ---@param extension string
    ---@return string
    getAvatarURL = function(self, size, extension) end,

    ---Returns a URL that can be used to view the user's default avatar. If provided, `size` must be a power of 2.
    ---@param self User
    ---@param size number
    ---@return string
    getDefaultAvatarURL = function(self, size) end,

    ---Returns a private channel that can be used to communicate directly to a user.
    ---@param self User
    ---@return PrivateChannel
    getPrivateChannel = function(self) end,

    ---Sends a message to the user. If `content` is a string, then it is sent as-is.
    ---If it is a table, more advanced formatting is allowed.
    ---@param self User
    ---@param content string
    ---@return Message
    send = function(self, content) end,

    ---Sends a message to the user with content formatted according to `string.format(content, ...)`.
    ---@param self User
    ---@param content string
    ---@return Message
    sendf = function(self, content, ...) end,
}

return Snowflake