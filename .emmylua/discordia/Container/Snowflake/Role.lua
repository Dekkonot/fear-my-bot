---@class Role
---@field client Client
---@field parent Container|Client
---@field createdAt number
---@field id SnowflakeId
---@field timestamp string
---@field color number
---@field emojis FilteredIterable
---@field guild Guild
---@field hoisted boolean
---@field managed boolean
---@field members FilteredIterable
---@field mentionString string
---@field mentionable boolean
---@field name string
---@field permissions number
---@field position number

local Role = {
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

    -- [[Role Methods]] --

    ---Permanently deletes the role.
    ---@param self Role
    ---@return boolean
    delete = function(self) end,

    ---Disables all permissions for this role.
    ---@param self Role
    ---@return boolean
    disableAllPermissions = function(self) end,

    ---Disallows anyone from mentioning this role in text messages.
    ---@param self Role
    ---@return boolean
    disableMentioning = function(self) end,

    ---Disables individual permissions for this role.
    ---@param self Role
    ---@return boolean
    disablePermissions = function(self, ...) end,

    ---Enables all permissions for this role.
    ---@param self Role
    ---@return boolean
    enableAllPermissions = function(self) end,

    ---Allows anyone to mention this role in text messages.
    ---@param self Role
    ---@return boolean
    enableMentioning = function(self) end,

    ---Enables individual permissions for this role.
    ---@param self Role
    ---@return boolean
    enablePermissions = function(self, ...) end,

    ---Returns a color object that reperesents the role's display color.
    ---@param self Role
    ---@return Color
    getColor = function(self) end,

    ---Returns a permissions object that represents the permissions that this role has enabled.
    ---@param self Role
    ---@return Permissions
    getPermissions = function(self) end,

    ---It causes members with this role to display above unhoisted roles in the member list.
    ---@param self Role
    ---@return boolean
    hoist = function(self) end,

    ---Moves a role down its list by `n` spaces. `n` defaults to `1` and is clamped to the lowest position.
    ---The positions of all channels are normalized.
    ---@param self Role
    ---@param n number
    ---@return boolean
    moveDown = function(self, n) end,

    ---Moves a role up its list by `n` spaces. `n` defaults to `1` and is clamped to the highest position.
    ---The positions of all channels are normalized.
    ---@param self Role
    ---@param n number
    ---@return boolean
    moveUp = function(self, n) end,

    ---Set the role's display color.
    ---@param self Role
    ---@param color Color
    ---@return boolean
    setColor = function(self, color) end,

    ---Sets the role's name. The name must be between 1 and 100 characters in length.
    ---@param self Role
    ---@param name string
    ---@return boolean
    setName = function(self, name) end,

    ---Sets the permissions that this role explicitly allows.
    ---@param self Role
    ---@param permissions Permissions
    ---@return boolean
    setPermissions = function(self, permissions) end,

    ---Causes members with this role to display amongst other unhoisted members.
    ---@param self Role
    ---@return boolean
    unhoist = function(self) end,
}

return Role