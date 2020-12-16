---@class GroupChannel

---@field client Client
---@field parent Container|Client
---@field createdAt number
---@field id SnowflakeId
---@field timestamp string
---@field mentionString string
---@field type enums.channelType
---@field messages WeakCache
---@field icon string|nil
---@field iconURL string|nil
---@field name string
---@field owner User|nil
---@field ownerId Snowflake
---@field recipients SecondaryCache

local GroupChannel = {
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

    -- [[TextChannel Methods]] --

    ---Indicates in the channel that the client's user "is typing".
    ---@param self TextChannel
    ---@return boolean
    broadcastTyping = function(self) end,

    ---Returns the first message found in the channel, if any exist.
    ---This is not cached. An HTTP request is made each time this method is called.
    ---@param self TextChannel
    ---@return Message
    getFirstMessage = function(self) end,

    ---Returns the last message found in the channel, if any exist.
    ---This is not cached. An HTTP request is made each time this method is called.
    ---@param self TextChannel
    ---@return Message
    getLastMessage = function(self) end,

    ---Gets a message object by ID.
    ---@param self TextChannel
    ---@param id SnowflakeId
    getMessage = function(self, id) end,

    ---Returns a newly constructed cache of between 1 and 100 (default = 50) messages in the channel.
    ---While the cache will never automatically gain or lose objects, they may be updated by gateway events.
    ---@param self TextChannel
    ---@param limit number
    ---@return SecondaryCache
    getMessages = function(self, limit) end,

    ---Returns a newly constructed cache of between 1 and 100 (default = 50) messages in the channel after the specified id.
    ---While the cache will never automatically gain or lose objects, they may be updated by gateway events.
    ---@param self TextChannel
    ---@param id SnowflakeId
    ---@param limit number
    ---@return SecondaryCache
    getMessagesAfter = function(self, id, limit) end,

    ---Returns a newly constructed cache of between 1 and 100 (default = 50) messages in the channel around the specified id.
    ---While the cache will never automatically gain or lose objects, they may be updated by gateway events.
    ---@param self TextChannel
    ---@param id SnowflakeId
    ---@param limit number
    ---@return SecondaryCache
    getMessagesAround = function(self, id, limit) end,

    ---Returns a newly constructed cache of between 1 and 100 (default = 50) messages in the channel before the specified id.
    ---While the cache will never automatically gain or lose objects, they may be updated by gateway events.
    ---@param self TextChannel
    ---@param id SnowflakeId
    ---@param limit number
    ---@return SecondaryCache
    getMessagesBefore = function(self, id, limit) end,

    ---Returns a newly constructed cache of up to 50 messages that are pinned in the channel.
    ---While the cache will never automatically gain or lose objects, they may be updated by gateway events.
    ---@param self TextChannel
    ---@return SecondaryCache
    getPinnedMessages = function(self) end,

    ---Sends a message to the channel. If `content` is a string, then it is sent as-is.
    ---If it is a table, more advanced formatting is allowed.
    ---@param self TextChannel
    ---@param content string
    ---@return Message
    send = function(self, content) end,

    ---Sends a message to the channel with content formatted according to `string.format(content, ...)`.
    ---@param self TextChannel
    ---@param content string
    ---@return Message
    sendf = function(self, content, ...) end,

    -- [[GroupChannel Methods]] --

    ---Adds a user to the channel.
    ---@param self GroupChannel
    ---@param id SnowflakeId
    ---@return boolean
    addRecipient = function(self, id) end,

    ---Removes the current user from the channel.
    ---@param self GroupChannel
    ---@return boolean
    leave = function(self) end,

    ---Removes a user from the channel.
    ---@param self GroupChannel
    ---@param id SnowflakeId
    ---@return boolean
    removeRecipient = function(self, id) end,

    ---Sets the channel's icon. To remove the icon, pass `nil`.
    ---@param self GroupChannel
    ---@param icon boolean
    setIcon = function(self, icon) end,

    ---Sets the channel's name. The name must be between 1 and 100 characters in length.
    ---@param self GroupChannel
    ---@param name string
    ---@return boolean
    setName = function(self, name) end,
}