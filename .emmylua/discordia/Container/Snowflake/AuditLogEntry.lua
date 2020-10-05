---@class AuditLogEntry

-- [[Container Fields]] --

---@field client Client
---@field parent Container|Client

-- [[Snowflake Fields]] --

---@field createdAt number
---@field id SnowflakeId
---@field timestamp string

-- [[AuditLogEntry Fields]] --

---@field actionType enums.actionType
---@field changes table|nil
---@field guild Guild
---@field options table|nil
---@field reason string|nil
---@field targetId SnowflakeId|nil
---@field userId SnowflakeId

local AuditLogEntry = {
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

    -- [[AuditLogEntry Methods]] --

    ---Returns two tables of the target's properties before the change and after the change.
    ---@param self AuditLogEntry
    ---@return table
    ---@return table
    getBeforeAfter = function(self) end,

    ---Gets the member object of the user who performed the changes.
    ---@param self AuditLogEntry
    ---@return Member|nil
    getMember = function(self) end,

    ---Gets the target object of the audit log entry.
    ---The returned object can be: Guild, GuildChannel, User, Member, Role, Webhook, Emoji, nil
    ---@param self AuditLogEntry
    ---@return Snowflake
    getTarget = function(self) end,

    ---Gets the user who performed the changes.
    ---@param self AuditLogEntry
    ---@return User
    getUser = function(self) end,
}

return AuditLogEntry