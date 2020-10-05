---@class Member

-- [[Container Fields]] --

---@field client Client
---@field parent Container|Client

-- [[UserPresence Fields]] --

---@field activity Activity|nil
---@field desktopStatus enums.status
---@field mobileStatus enums.status
---@field status enums.status
---@field user User
---@field webStatus enums.status

-- [[Member Fields]] --

---@field deafened boolean
---@field guild Guild
---@field highestRole Role
---@field joinedAt Timestamp
---@field muted boolean
---@field name string
---@field nickname string|nil
---@field premiumSince Timestamp
---@field roles ArrayIterable
---@field voiceChannel GuildVoiceChannel|nil

local Member = {
    -- [[UserPresence Methods]] --

    ---Returns `UserPresence.user.id`.
    ---@param self UserPresence
    ---@return string
    __hash = function(self) end,

    -- [[Member Methods]] --

    ---Adds a role from the member. If the member already has the role, no action is taken.
    ---The `everyone` role cannot be added explicitly.
    ---@param self Member
    ---@param id SnowflakeId
    ---@return boolean
    addRole = function(self, id) end,

    ---Bans the member from its guild with an optional `reason`, deleting `days` messages (default = 0).
    ---@param self Member
    ---@param reason string
    ---@param days number
    ban = function(self, reason, days) end,

    ---Deafens the member in its guild.
    ---@param self Member
    ---@return boolean
    deafen = function(self) end,

    ---Returns a color object that represents the member's color as determined by its highest colored role.
    ---If the member has no colored roles, then the default color with a value of `0` is returned.
    ---@param self Member
    ---@return Color
    getColor = function(self) end,

    ---Returns a Permissions object that represents the member's total permissions for the guild,
    ---or for a specific channel if one is provided. If you just need to check one permission, use `Member:hasPermission`.
    ---@param self Member
    ---@param channel GuildChannel
    ---@return Permissions
    getPermissions = function(self, channel) end,

    ---Checks whether the member has a specific permission.
    ---If `channel` is provided, it will check channel-specific permissions.
    ---Otherwise, it will check guild-level permissions.
    ---
    ---This operation is relatively expensive. If you need to check multiple permissions at once, use `Member:getPermissions`.
    ---@param self Member
    ---@param channel GuildChannel
    ---@param perms enums.permission
    ---@return boolean
    hasPermission = function(self, channel, perms) end,

    ---Checks whether the member has a specific role. This will return true for the `everyone` role.
    ---@param self Member
    ---@param id SnowflakeId
    ---@return boolean
    hasRole = function(self, id) end,

    ---Removes the member from its guild with an optional reason.
    ---@param self Member
    ---@param reason string
    ---@return boolean
    kick = function(self, reason) end,

    ---Mutes the member in its guild.
    ---@param self Member
    ---@return boolean
    mute = function(self) end,

    ---Removes a role from the member. If the member does not have a role, no action is taken.
    ---The `everyone` role cannot be removed.
    ---@param self Member
    ---@param id SnowflakeId
    ---@return boolean
    removeRole = function(self, id) end,

    ---Sets the member's nickname. This must be between 1 and 32 characters in length.
    ---Pass `nil` to remove the nickname.
    ---@param self Member
    ---@param nick string
    ---@return boolean
    setNickname = function(self, nick) end,

    ---Moves the member to a new voice channel, but only if it's already in one.
    ---Due to internal complexities, `Member.voiceChannel` will update separately from this method.
    ---@param self Member
    ---@param id SnowflakeId
    ---@return boolean
    setVoiceChannel = function(self, id) end,

    ---Unbans the member from its guild with an optional reasoon.
    ---@param self Guild
    ---@param reason string
    ---@return boolean
    unban = function(self, reason) end,

    ---Undefans the member in its guild.
    ---@param self Member
    ---@return boolean
    undeafen = function(self) end,

    ---Unmutes the member in its guild.
    ---@param self Member
    ---@return boolean
    unmute = function(self) end,
}

return Member