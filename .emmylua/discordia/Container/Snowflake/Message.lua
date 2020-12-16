---@class Message
---@field client Client
---@field parent Container|Client
---@field createdAt number
---@field id SnowflakeId
---@field timestamp string
---@field attachment table|nil
---@field attachments table|nil
---@field author User
---@field channel TextChannel
---@field cleanContent string
---@field content string
---@field editedTimestamp Timestamp|nil
---@field embed table|nil
---@field embeds table|nil
---@field guild Guild|nil
---@field link string
---@field member Member|nil
---@field mentionChannels ArrayIterable
---@field mentionedEmojis ArrayIterable
---@field mentionedRoles ArrayIterable
---@field mentionedUsers ArrayIterable
---@field mentionsEveryone boolean
---@field nonce any
---@field oldContent table<Timestamp,string>
---@field pinned boolean
---@field reactions Cache
---@field tts boolean
---@field type enums.messageType
---@field webhookId SnowflakeId|nil

local Message = {
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

    -- [[Message Methods]] --

    ---Adds a reaction to the message.
    ---This does not return the new Reaction object. Wait for the `reactionAdd` event instead.
    ---@param self Message
    ---@return boolean
    addReaction = function(self, emoji) end,

    ---Removes all reactions from the message.
    ---@param self Message
    ---@return boolean
    clearReactions = function(self) end,

    ---Permanently deletes the message.
    ---@param self Message
    ---@return boolean
    delete = function(self) end,

    ---Indicates whether the message has a particular flag.
    ---@param self Message
    ---@return boolean
    hasFlag = function(self, flag) end,

    ---Hides all embeds for this message.
    ---@param self Message
    ---@return boolean
    hideEmbeds = function(self) end,

    ---Pins the message in its channel.
    ---@param self Message
    ---@return boolean
    pin = function(self) end,

    ---Removes a reaction from the message.
    ---If `id` is provided, it will remove that user's reaction instead.
    ---This does not return the removed Reaction object. Wait for the `reactionRemove` event instead.
    ---@param self Message
    ---@param emoji SnowflakeId|string
    ---@param id SnowflakeId
    ---@return boolean
    removeReaction = function(self, emoji, id) end,

    ---Sends a message in the same channel as the message. If `content` is a string, then it is sent as-is.
    ---If it is a table, more advanced formatting is allowed.
    ---@param self Message
    ---@param content string
    ---@return Message
    reply = function(self, content) end,

    ---Sets the message's content. The content must be between 1 and 2000 characters in length.
    ---@param self Message
    ---@param content string
    ---@return boolean
    setContent = function(self, content) end,

    ---Sets the message's embed.
    ---@param self Message
    ---@param embed table
    ---@return boolean
    setEmbed = function(self, embed) end,

    ---Shows all embeds for this message.
    ---@param self Message
    ---@return boolean
    showEmbeds = function(self) end,

    ---Unpins the message from its channel.
    ---@param self Message
    ---@return boolean
    unpin = function(self) end,

    ---Sets multiple properties of the message at the same time using a table.
    ---Only `content` and `embed` are valid fields in this table.
    ---@param self Message
    ---@param data table
    ---@return boolean
    update = function(self, data) end,
}

return Message