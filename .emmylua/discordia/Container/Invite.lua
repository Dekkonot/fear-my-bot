---@class Invite

-- [[Container Fields]] --

---@field client Client
---@field parent Container|Client

-- [[Invite Fields]] --

---@field approximateMemberCount number|nil
---@field approximatePresenceCount number|nil
---@field channelId SnowflakeId
---@field channelName string
---@field channelType enums.channelType
---@field code string
---@field createdAt string|nil
---@field guildBanner string|nil
---@field guildBannerURL string|nil
---@field guildDescription string|nil
---@field guildIcon string|nil
---@field guildIconURL string|nil
---@field guildId SnowflakeId
---@field guildName string
---@field guildSplash string|nil
---@field guildSplashURL string|nil
---@field guildVerificationLevel enums.verificationLevel
---@field inviter User|nil
---@field maxAge number|nil
---@field maxUses number|nil
---@field revoked boolean|nil
---@field temporary boolean|nil
---@field uses number|nil

local Invite = {
    -- [[Invite Methods]] --

    ---Returns `Invite.code`.
    ---@param self Invite
    ---@return string
    __hash = function(self) end,

    ---Permanently deletes the invite. The current user must have permission to do this.
    ---@param self Invite
    ---@return boolean
    delete = function(self) end,
}

return Invite