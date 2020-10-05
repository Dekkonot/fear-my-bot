---@class GuildVoiceChannel

-- [[Container Fields]] --

---@field client Client
---@field parent Container|Client

-- [[Snowflake Fields]] --

---@field createdAt number
---@field id SnowflakeId
---@field timestamp string

-- [[Channel Fields]] --

---@field mentionString string
---@field type enums.channelType

-- [[GuildChannel Fields]] --

---@field category GuildCategoryChannel|nil
---@field guild Guild
---@field name string
---@field permissionOverwrites Cache
---@field position number
---@field private private boolean

-- [[GuildVoiceChannel Fields]] --

---@field bitrate number
---@field connectedMembers TableIterable
---@field connection VoiceConnection|nil
---@field userLimit number

local GuildVoiceChannel = {
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

    -- [[GuildVoiceChannel Methods]] --

    ---Joins this channel and form a connection to the Voice Gateway.
    ---@param self GuildVoiceChannel
    ---@return VoiceConnection
    join = function(self) end,

    ---Leaves this channel if there is an existing voice connection to it.
    ---Equivalent to `GuildVoiceChannel.connection:close()`.
    ---@param self GuildVoiceChannel
    ---@return boolean
    leave = function(self) end,

    ---Sets the channel's audio bitrate in bits per second.
    ---The bitrate must be `8000` or higher. The max value depends upon the status of the server.
    ---@param self GuildVoiceChannel
    ---@param bitrate number
    ---@return boolean
    setBitrate = function(self, bitrate) end,

    ---Sets the channel's user limit. This must be between `0` and `99`, where `0` is unlimited.
    ---@param self GuildVoiceChannel
    ---@param limit number
    ---@return boolean
    setUserLimit = function(self, limit) end,
}