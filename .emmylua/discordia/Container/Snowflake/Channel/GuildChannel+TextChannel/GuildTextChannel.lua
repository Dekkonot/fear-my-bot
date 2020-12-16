---@class GuildTextChannel : TextChannel
---@field client Client
---@field parent Container|Client
---@field createdAt number
---@field id SnowflakeId
---@field timestamp string
---@field mentionString string
---@field type enums.channelType
---@field category GuildCategoryChannel|nil
---@field guild Guild
---@field name string
---@field permissionOverwrites Cache
---@field position number
---@field private private boolean
---@field messages WeakCache
---@field isNews boolean
---@field members FilteredIterable
---@field nsfw boolean
---@field rateLimit number
---@field topic string|nil

local GuildTextChannel = {
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

    -- [[GuildChannel Methods]] --

    ---Creates an invite to the channel.
    ---If included, `payload` should be a table that has one or more of the following fields:
    --- - `max_age`: number - time in seconds until expiration (default = 86400, 24 hours)
    --- - `max_uses`: number - number of times this invite can be used (default = 0, unlimited)
    --- - `temporary`: boolean - whether the invite grants temporary membership (default = false)
    --- - `unique`: boolean - whether a unique code should be guaranteed (default = false)
    ---@param self GuildChannel
    ---@param payload table
    ---@return Invite
    createInvite = function(self, payload) end,

    ---Permanently deletes the channel.
    ---@param self GuildChannel
    ---@return boolean
    delete = function(self) end,

    ---Returns a newly constructed cache of all invite objects for the channel.
    ---The cache is not automatically updated; you must call this method again to get the updated objects.
    ---@param self GuildChannel
    ---@return Cache
    getInvites = function(self) end,

    ---Returns a permission overwrite object corresponding to the provided member or role object.
    ---If an overwrite is not found, an empty overwrite with zero-permissions is returned instead.
    ---The role and member must exist in the same guild as the channel.
    ---@param self GuildChannel
    ---@param object Role|Member
    getPermissionOverwriteFor = function(self, object) end,

    ---Moves a channel down its list by `n` spaces. `n` defaults to `1` and is clamped to the lowest position.
    ---The positions of all channels are normalized.
    ---@param self GuildChannel
    ---@param n number
    ---@return boolean
    moveDown = function(self, n) end,

    ---Moves a channel up its list by `n` spaces. `n` defaults to `1` and is clamped to the highest position.
    ---The positions of all channels are normalized.
    ---@param self GuildChannel
    ---@param n number
    ---@return boolean
    moveUp = function(self, n) end,

    ---Sets the channel's parent category to the one specified.
    ---@param self TextChannel
    ---@param id SnowflakeId
    ---@return boolean
    setCategory = function(self, id) end,

    ---Sets the channel's name. The name must be between 2 and 100 characters in length.
    ---@param self GuildChannel
    ---@param name string
    ---@return boolean
    setName = function(self, name) end,

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

    -- [[GuildTextChannel Methods]] --

    ---Bulk deletes multiple messages from the channel.
    ---This method will delete between `2` and `100` messages, and they must not be more than 2 weeks old.
    ---@param self GuildTextChannel
    ---@param messages Message[]
    ---@return boolean
    bulkDelete = function(self, messages) end,

    ---Creates a webho0ok for this channel. The name must be between 2 and 32 characters in length.
    ---@param self GuildTextChannel
    ---@param name string
    ---@return Webhook
    createWebhook = function(self, name) end,

    ---Disables the NSFW setting for the channel.
    ---@param self GuildTextChannel
    ---@return boolean
    disableNSFW = function(self) end,

    ---Enables the NSFW setting for the channel.
    ---@param self GuildTextChannel
    ---@return boolean
    enableNSFW = function(self) end,

    ---Returns a newly constructed cache of all webhook objects for the channel.
    ---The cache is not automatically updated; you must call this method again to get the updated objects.
    ---@param self GuildTextChannel
    ---@return Cache
    getWebhooks = function(self) end,

    ---Sets the channel's slowmode rate limit in seconds. This must be between `0` and `120`.
    ---Passing `0` or `nil` will clear the limit.
    ---@param self GuildTextChannel
    ---@param limit number
    ---@return boolean
    setRateLimit = function(self, limit) end,

    ---Sets the channel's topic. The topic must be between 1 and 1024 characters in length.
    ---Pass `nil` to remove the channel topic.
    ---@param self GuildTextChannel
    ---@param topic string
    ---@return boolean
    setTopic = function(self, topic) end,
}

return GuildTextChannel