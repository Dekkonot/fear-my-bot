---@class Guild

-- [[Container Fields]] --

---@field client Client
---@field parent Container|Client

-- [[Snowflake Fields]] --

---@field createdAt number
---@field id SnowflakeId
---@field timestamp string

-- [[Guild Stuff]] --

---@field afkChannel GuildVoiceChannel|nil
---@field afkChannelId SnowflakeId|nil
---@field afkTimeout number
---@field banner string|nil
---@field bannerURL string|nil
---@field categories Cache
---@field connection VoiceConnection|nil
---@field defaultRole Role
---@field description string|nil
---@field emojis Cache
---@field explicitContentSetting enums.explicitContentLevel
---@field features table
---@field icon string|nil
---@field iconURL string|nil
---@field joinedAt Timestamp
---@field large boolean
---@field lazy boolean
---@field maxMembers number|nil
---@field maxPresences number|nil
---@field me Member|nil
---@field members Cache
---@field mfaLevel number
---@field name string
---@field notificationSetting enums.notificationSetting
---@field owner Member|nil
---@field ownerId SnowflakeId
---@field premiumSubscriptionCount number
---@field premiumTier enums.premiumTier
---@field region string
---@field roles Cache
---@field shardId number
---@field splash string|nil
---@field splashURL string|nil
---@field systemChannel GuildTextChannel|nil
---@field systemChannelId SnowflakeId|nil
---@field textChannels Cache
---@field totalMemberCount number
---@field unavailable boolean
---@field vanityCode string|nil
---@field verificationLevel enums.verificationLevel
---@field voiceChannels Cache

local guild = {
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

    -- [[Guild Methods]] --

    ---Bans a user/member from the guild with an optional `reason`.
    ---The `days` parameter is the number of days to consider when purging messages, up to 7.
    ---@param self Guild
    ---@param id SnowflakeId
    ---@param reason string
    ---@param days number
    ---@return boolean
    banUser = function(self, id, reason, days) end,

    ---Creates a channel category in this guild. The name must be between 2 and 100 characters in length.
    ---@param self Guild
    ---@param name string
    ---@return GuildCategoryChannel
    createCategory = function(self, name) end,

    ---Creates a new emoji in this guild. The name must be between 2 and 32 characters in length.
    ---The image must not be over 256kb. Any higher will return a bad request.
    ---@param self Guild
    ---@param name string
    ---@param image string
    ---@return Emoji
    createEmoji = function(self, name, image) end,

    ---Creates a new role in this guild. The name must be between 1 and 100 characters in length.
    ---@param self string
    ---@param name string
    ---@return Role
    createRole = function(self, name) end,

    ---Creates a new text channel in this guild. The name must be between 2 and 100 characters in length.
    ---@param self Guild
    ---@param name string
    ---@return GuildTextChannel
    createTextChannel = function(self, name) end,

    ---Creates a new voice channel in this guild. The name must be between 2 and 100 characters in length.
    ---@param self Guild
    ---@param name string
    ---@return GuildVoiceChannel
    createVoiceChannel = function(self, name) end,

    ---Permanently deletes the guild. The current user must own the guild.
    ---@param self Guild
    ---@return boolean
    delete = function(self) end,

    ---Returns a newly constructed Cache of audit log entries for the guild.
    ---The cache is not automatically updated; you must call this method again to get the updated object.
    ---If included, `query` should be a table that has one or more of the following fields:
    --- - `limit`: number
    --- - `user`: User ID
    --- - `before`: AuditLogEntry ID
    --- - `type`: enum.actionType
    ---@param self Guild
    ---@param query table<string, number|SnowflakeId|enums.actionType>
    ---@return Cache
    getAuditLogs = function(self, query) end,

    ---Returns a Ban object for the given user if that user is banned, otherwise returns `nil`.
    ---@param self Guild
    ---@param id SnowflakeId
    ---@return Ban
    getBan = function(self, id) end,

    ---Returns a newly constructed cache of all ban objects for the guild.
    ---The cache and its contained bans are not automatically updated;
    ---you must call this method again to get the updated object.
    ---@param self Guild
    ---@return Cache
    getBans = function(self) end,

    ---Gets a text, voice, or category channel object by ID.
    ---@param self Guild
    ---@param id SnowflakeId
    ---@return GuildChannel
    getChannel = function(self, id) end,

    ---Gets an emoji object by ID.
    ---@param self Guild
    ---@param id SnowflakeId
    ---@return Emoji
    getEmoji = function(self, id) end,

    ---Returns a newly constructed cache of all invite objects for the guild.
    ---The cache and its contained invites are not automatically updated;
    ---you must call this method again to get the updated object.
    ---@param self Guild
    ---@return Cache
    getInvites = function(self) end,

    ---Gets a member object by ID.
    ---@param self Guild
    ---@param id SnowflakeId
    ---@return Member
    getMember = function(self, id) end,

    ---Returns the number of members that would be pruned from the guild if a prune were executed.
    ---@param self Guild
    ---@param days number
    ---@return number
    getPruneCount = function(self, days) end,

    ---Gets a role object by ID.
    ---@param self Guild
    ---@param id SnowflakeId
    ---@return Role
    getRole = function(self, id) end,

    ---Returns a newly constructed cache of all webhook objects for the guild.
    ---The cache and its contained webhooks are not automatically updated;
    ---you must call this method again to get the updated object.
    ---@param self Guild
    ---@return Cache
    getWebhooks = function(self) end,

    ---Kicks a user/member from the guild, with an optional `reason`.
    ---@param self Guild
    ---@param id SnowflakeId
    ---@param reason string
    ---@return boolean
    kickUser = function(self, id, reason) end,

    ---Causes the current user to leave the guild.
    ---@param self Guild
    ---@return boolean
    leave = function(self) end,

    ---Returns a raw data table that contains a list of available voice regions for this guild,
    ---as provided by Discord, with no additional parsing.
    ---@param self Guild
    ---@return table
    listVoiceRegions = function(self) end,

    ---Removes inactive, roleless members from the guild who have not been online in the last provided `days`.
    ---If `count` is true, the numer of pruned members is returned. Otherwise, `0` is returned.
    ---@param self Guild
    ---@param days number
    ---@param count boolean
    ---@return number
    pruneMembers = function(self, days, count) end,

    ---Asynchronously loads all members for this guild.
    ---You do not need to call this if the `cacheAllMembers` client option
    ---(and the `syncGuilds` option for user-accounts) is enabled on start-up.
    ---@param self Guild
    ---@return boolean
    requestMembers = function(self) end,

    ---Sets the guild's AFK channel.
    ---@param self Guild
    ---@param id SnowflakeId
    ---@return boolean
    setAFKChannel = function(self, id) end,

    ---Sets the guild's AFK timeout in seconds.
    ---@param self Guild
    ---@param timeout number
    ---@return number
    setAFKTimeout = function(self, timeout) end,

    ---Sets the guild's banner. To remove the banner, pass `nil`.
    ---@param self Guild
    ---@param banner string
    ---@return boolean
    setBanner = function(self, banner) end,

    ---Sets the guild's explicit content level setting.
    ---@param self Guild
    ---@param contentLevel enums.explicitContentLevel
    ---@return boolean
    setExplicitContentSetting = function(self, contentLevel) end,

    ---Sets the guild's icon. To remove the icon, pass `nil`.
    ---@param self Guild
    ---@param icon string
    ---@return boolean
    setIcon = function(self, icon) end,

    ---Sets the guild's name. The name must be between 2 and 100 characters in length.
    ---@param self Guild
    ---@param name string
    ---@return boolean
    setName = function(self, name) end,

    ---Sets the guild's default notification setting.
    ---@param self Guild
    ---@param notificationSetting enums.notificationSetting
    ---@return boolean
    setNotificationSetting = function(self, notificationSetting) end,

    ---Transfers ownership of the guild to another user. Only the current owner of the guild can do this.
    ---@param self Guild
    ---@param id SnowflakeId
    ---@return boolean
    setOwner = function(self, id) end,

    ---Sets the guild's voice region (e.g.: `us-east`).
    ---@param self Guild
    ---@param region string
    ---@return boolean
    setRegion = function(self, region) end,

    ---Sets the guild's splash. To remove the splash, pass `nil`.
    ---@param self Guild
    ---@param splash string
    ---@return boolean
    setSplash = function(self, splash) end,

    ---Sets the guild's system message channel. This is the channel used for things like join messages.
    ---@param self Guild
    ---@param id SnowflakeId
    setSystemChannel = function(self, id) end,

    ---Sets the guiild's verification level setting.
    ---@param self Guild
    ---@param verificationLevel enums.verificationLevel
    ---@return boolean
    setVerificationLevel = function(self, verificationLevel) end,

    ---Asynchronously loads certain data and enables the receiving of certain events for this guild.
    ---Note: This is only necessary for user accounts. Bots never need to sync guilds.
    ---@param self Guild
    ---@return boolean
    sync = function(self) end,

    ---Unbans a user/member from the guild with an optional `reason`.
    ---@param self Guild
    ---@param id SnowflakeId
    ---@param reason string
    ---@return boolean
    unbanUser = function(self, id, reason) end,
}

return guild