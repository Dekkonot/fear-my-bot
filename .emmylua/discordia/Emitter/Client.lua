---@class Client

-- [[Client Fields]]

---@field email string|nil
---@field groupChannels Cache
---@field guilds Cache
---@field mfaEnabled boolean|nil
---@field owner User|nil
---@field privateChannels Cache
---@field relationships Cache
---@field shardCount number|nil
---@field totalShardCount number|nil
---@field user User|nil
---@field users Cache
---@field verified boolean|nil

local Client = {
    -- [[Emitter Methods]] --

    -- Omitting `emit` here since it shouldn't be called by the user.

    ---Returns the number of callbacks registered to the named event.
    ---@param self Emitter
    ---@param name string
    ---@return number
    getListenerCount = function(self, name) end,

    ---Returns an iterator for all callbacks registered to the named event.
    ---@param self Emitter
    ---@param name string
    ---@return function
    getListeners = function(self, name) end,

    ---Subscribes `callback` to be called every time the named event is emmited.
    ---Callbacks registered with this method will be automatically wrapped as a new coroutine when they are called.
    ---Returns the original callback.
    ---@param self Emitter
    ---@param name string
    ---@param callback function
    ---@return function
    on = function(self, name, callback) end,

    ---Subscribes `callback` to be called every time the named event is emmited.
    ---Callbacks registered with this method will **not** be wrapped as a new coroutine when they are called.
    ---Returns the original callback.
    ---@param self Emitter
    ---@param name string
    ---@param callback function
    ---@return function
    onSync = function(self, name, callback) end,

    ---Subscribes `callback` to be called only the next time the named event is emmited.
    ---Callbacks registered with this method will be wrapped as a new coroutine when they are called.
    ---Returns the original callback.
    ---@param self Emitter
    ---@param name string
    ---@param callback function
    ---@return function
    once = function(self, name, callback) end,

    ---Subscribes `callback` to be called only the next time the named event is emmited.
    ---Callbacks registered with this method will **not** be wrapped as a new coroutine when they are called.
    ---Returns the original callback.
    ---@param self Emitter
    ---@param name string
    ---@param callback function
    ---@return function
    onceSync = function(self, name, callback) end,

    ---Unregistered all callbacks for the emitter.
    ---If `name` is passed, then only callbacks for that event are unregistered.
    ---@param self Emitter
    ---@param name string
    removeAllListeners = function(self, name) end,

    ---Unregisters all instances of the callback from the named event.
    ---@param name string
    ---@param callback function
    removeListener = function(name, callback) end,

    ---Yields the current coroutine until the named event is emitted.
    ---If a timeout (in milliseconds) is provided, the function will resume after that time regardless of if the event has been emitted and `false` will be returned.
    ---Otherwise, `true` will be returned.
    ---If a predicate is provided, events that do not satisfy it will be ignored.
    ---@param self Emitter
    ---@param name string
    ---@param timeout number
    ---@param predicate function
    ---@return boolean
    waitFor = function(self, name, timeout, predicate) end,

    -- [[Client Methods]] --

    ---Creates a new group channel. This method is only available for user accounts.
    ---@param self Client
    ---@return GroupChannel
    createGroupChannel = function(self) end,

    ---Creates a new guild. The name must be between 2 and 100 characters in length.
    ---This method may not work if this current user is in too many guilds.
    ---Note that this does not return the created guild object.
    ---@param self Client
    ---@param name string
    ---@return boolean
    createGuild = function(self, name) end,

    ---Returns a raw data table that contains information about the current OAuth2 application.
    ---No additional formatting is done beyond what is provided by Discord's API.
    ---@param self Client
    ---@return table
    getApplicationInformation = function(self) end,

    ---Gets a channel object by ID.
    ---For guild channels, the current user must be in the channel's guild, and the client must be running the appropriate shard that serves the guild.
    ---For private channels, the channel must have been previously opened and cached by the client.
    ---@param self Client
    ---@param id SnowflakeId
    ---@return Channel
    getChannel = function(self, id) end,

    ---Returns a raw data table that contains a list of connections as provided by Discord.
    ---No additional formatting is done beyond what is provided by Discord's API.
    ---This is unrelated to voice connections.
    ---@param self Client
    ---@return table
    getConnections = function(self) end,

    ---Gets an emoji object by ID. The current user must be in the emoji's guild, and the client must be running the appropriate shard that serves the guild.
    ---@param self Client
    ---@param id SnowflakeId
    ---@return Emoji
    getEmoji = function(self, id) end,

    ---Gets a guild object by ID. The current user must be in the guild, and the client must be running the appropriate shard that serves the guild.
    ---@param self Client
    ---@param id SnowflakeId
    ---@return Guild
    getGuild = function(self, id) end,

    ---Gets an invite object by code. This makes a request to obtain a static object and is not cached.
    ---To update the invite, request it from the Client or Guild again.
    ---@param self Client
    ---@param code string
    ---@param counts boolean
    ---@return Invite
    getInvite = function(self, code, counts) end,

    ---Gets a role object by ID. The current user must be in the role's guild, and the client must be running the appropriate shard that serves the guild.
    ---@param self Client
    ---@param id SnowflakeId
    ---@return Role
    getRole = function(self, id) end,

    ---Gets a user object by ID. Under rare conditions, the returned user object may be outdated.
    ---@param self Client
    ---@param id SnowflakeId
    ---@return User
    getUser = function(self, id) end,

    ---Gets a webhook object by ID. This makes a request to obtain a static object and is not cached.
    ---To update the webhook, request it from the Client or Guild again.
    ---@param self Client
    ---@param id SnowflakeId
    ---@return Webhook
    getWebhook = function(self, id) end,

    ---Returns a raw data table that contains a list of voice regions as provided by Discord.
    ---No additional formatting is done beyond what is provided by Discord's API.
    ---@param self Client
    ---@return table
    listVoiceRegions = function(self) end,

    ---Authenticates the current user via HTTPS and launches as many WSS gateway shards as are required/requested.
    ---This should be the last method called after all other code and event handlers have been initialized.
    ---If `presence` is provided, it will act as if the user called `setStatus` and `setGame` after `run`.
    ---@param self Client
    ---@param token string
    ---@param presence table
    run = function(self, token, presence) end,

    ---Sets the current user's AFK status on all shards that are managed by this client.
    ---@param self Client
    ---@param afk boolean
    setAFK = function(self, afk) end,

    ---Sets the current user's avatar. To remove the avatar, pass `nil`. This does not change the application image.
    ---@param self Client
    ---@param avatar string
    ---@return boolean
    setAvatar = function(self, avatar) end,

    ---Sets the current user's game on all shards that are managed by this client. If a string is passed, it is treated as the game name.
    ---If a table is passed, it must have a `name` field and may have a `url` or `type` field. Pass `nil` to remove the game status.
    ---@param self Client
    ---@param game string|table
    setGame = function(self, game) end,

    ---Sets the current user's status on all shards that are managed by this client.
    ---@param self Client
    ---@param status enums.status
    setStatus = function(self, status) end,

    ---Sets the client's username. This must be between 2 and 32 characters in length.
    ---This does not change the application name.
    ---@param self Client
    ---@param username string
    ---@return boolean
    setUsername = function(self, username) end,

    ---Disconnects all shards and effectively stops their loops.
    ---This does not empty any data that the client has cached.
    ---@param self Client
    stop = function(self) end,
}

return Client