---@class PermissionOverwrite

-- [[Container Fields]] --

---@field client Client
---@field parent Container|Client

-- [[Snowflake Fields]] --

---@field createdAt number
---@field id SnowflakeId
---@field timestamp string

-- [[PermissionOverwrite Fields]] --

---@field allowedPermissions number
---@field channel GuildChannel
---@field deniedPermissions number
---@field guild Guild
---@field type string

local PermissionOverwrite = {
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

    -- [[PermissionOverwrite]] --

    ---Allows all permissions in this overwrite.
    ---@param self PermissionOverwrite
    ---@return boolean
    allowAllPermissions = function(self) end,

    ---Allows individual permissions in this overwrite.
    ---@param self PermissionOverwrite
    ---@return boolean
    allowPermissions = function(self, ...) end,

    ---Clears all permissions in this overwrite.
    ---@param self PermissionOverwrite
    ---@return boolean
    clearAllPermissions = function(self) end,

    ---Clears individual permissions in this overwrite.
    ---@param self PermissionOverwrite
    ---@return boolean
    clearPermissions = function(self, ...) end,

    ---Deletes the permission overwrite.
    ---This can be undone by creating a new version of the overwrite.
    ---@param self PermissionOverwrite
    ---@return boolean
    delete = function(self) end,

    ---Denies all permissions in this overwrite.
    ---@param self PermissionOverwrite
    ---@return boolean
    denyAllPermissions = function(self) end,

    ---Denies individual permissions in this overwrite.
    ---@param self PermissionOverwrite
    ---@return boolean
    denyPermissions = function(self, ...) end,

    ---Returns a permissions object that represents the permissions that this overwrite explicitly allows.
    ---@param self PermissionOverwrite
    ---@return Permissions
    getAllowedPermissions = function(self) end,

    ---Returns a permissions object that represents the permissions that this overwrite explicitly denies.
    ---@param self PermissionOverwrite
    ---@return Permissions
    getDeniedPermissions = function(self) end,

    ---Returns the object associated with this overrwrite, either a role or a member.
    ---@param self PermissionOverwrite
    ---@return Member|Role
    getObject = function(self) end,

    ---Sets the permissions that this overwrite explicitly allows.
    ---@param self PermissionOverwrite
    ---@param allowed Permissions
    ---@return boolean
    setAllowedPermissions = function(self, allowed) end,

    ---Sets the permissions that this overwrite explicitly denies.
    ---@param self PermissionOverwrite
    ---@param denied Permissions
    ---@return boolean
    setDeniedPermissions = function(self, denied) end,

    ---Sets the permissions that this overwrite explicitly allows and denies.
    ---This method does **not** resolve conflicts. Be sure to use correct parameters.
    ---@param self PermissionOverwrite
    ---@param allowed Permissions
    ---@param denied Permissions
    ---@return boolean
    setPermissions = function(self, allowed, denied) end,
}

return PermissionOverwrite