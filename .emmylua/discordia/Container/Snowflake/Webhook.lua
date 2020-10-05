---@class Webhook

-- [[Container Fields]] --

---@field client Client
---@field parent Container|Client

-- [[Snowflake Fields]] --

---@field createdAt number
---@field id SnowflakeId
---@field timestamp string

-- [[Webhook Fields]] --

---@field avatar string|nil
---@field avatarURL string
---@field channelId SnowflakeId
---@field defaultAvatar enums.defaultAvatar
---@field defaultAvatarURL string
---@field guildId SnowflakeId
---@field name string
---@field token string
---@field type enums.webhookType
---@field user User|nil

local Webhook = {
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

    ---Permanently deletes the webhook.
    ---@param self Webhook
    ---@return boolean
    delete = function(self) end,

    ---Returns a URL that can be used to view the webhooks's full avatar, or its default avatar if it doesn't have one. If provided, `size` must be a power of 2.
    ---If `extension` is provided, it must be a valid image format.
    ---@param self Webhook
    ---@param size number
    ---@param extension string
    ---@return string
    getAvatarURL = function(self, size, extension) end,

    ---Returns a URL that can be used to view the webhook's default avatar.
    ---@param self Webhook
    ---@param size number
    ---@return string
    getDefaultAvatarURL = function(self, size) end,

    ---Sets the webhook's avatar. If `nil` is passed, the avatar is removed.
    ---@param self Webhook
    ---@param avatar string
    ---@return boolean
    setAvatar = function(self, avatar) end,

    ---Sets the webhook's name. The name must be between 2 and 32 characters in length.
    ---@param self Webhook
    ---@param name string
    ---@return boolean
    setName = function(self, name) end,
}

return Webhook