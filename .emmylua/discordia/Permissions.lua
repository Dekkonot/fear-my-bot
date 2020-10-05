---@class Permissions

-- [[Permissions Fields]] --

---@field value number

local Permissions = {
    -- [[Permissions Methods]] --

    ---Returns a new Permissions object that contains the permissions that are not in `self` but are in `other`.
    ---Or, if `other` is not provided, the set of all permissions. Equivalent to `~self & other`.
    ---@param self Permissions
    ---@param other Permissions
    ---@return Permissions
    complement = function(self, other) end,

    ---Returns a new copy of the original Permissions object.
    ---@param self Permissions
    ---@return Permissions
    copy = function(self) end,

    ---Disables one or more permissions. See the `permission` enum for acceptable permission values.
    ---@param self Permissions
    disable = function(self, ...) end,

    ---Disables all permissions.
    ---@param self Permissions
    disableAll = function(self) end,

    ---Enables one or more permissions. See the `permission` enum for acceptable permission values.
    ---@param self Permissions
    enable = function(self, ...) end,

    ---Enables all permissions.
    ---@param self Permissions
    enableAll = function(self) end,

    ---Returns whether this object has one or more permissions. See the `permission` enum for acceptable permission values.
    ---@param self Permissions
    ---@return boolean
    has = function(self, ...) end,

    ---Returns a new Permissions object that contains the permissions that are in both `self` and `other`.
    ---Equivalent to `self & other`.
    ---@param self Permissions
    ---@param other Permissions
    ---@return Permissions
    intersection = function(self, other) end,

    ---Returns a new Permissions object that contains the permissions that are not in `self` or `other`.
    ---Equivalent to `self ^ other`.
    ---@param self Permissions
    ---@param other Permissions
    ---@return Permissions
    difference = function(self, other) end,

    ---Returns an array of the names of the permissions that this object represents.
    ---@param self Permissions
    ---@return string[]
    toArray = function(self) end,

    ---Returns a hexadecimal string that represents the Permissions's value.
    ---@param self Permissions
    ---@return string
    toHex = function(self) end,

    ---Returns a table that represents the permission's value, where the keys are the permission name and the values are `true` or `false`.
    ---@param self Permissions
    ---@return table<string, boolean>
    toTable = function(self) end,

    ---Returns a new Permissions object that contains the permissions that are in either `self` and `other`.
    ---Equivalent to `self | other`.
    ---@param self Permissions
    ---@param other Permissions
    ---@return Permissions
    union = function(self, other) end,

    -- [[Permissions Static Functions]] --

    ---Constructs a new Permissions object with all permissions enabled.
    ---@return Permissions
    all = function() end,

    ---Contructs a new Permissions object with all of the defined permissions enabled.
    ---See the `permission` enum for a list of acceptable permission values.
    ---@return Permissions
    fromMany = function(...) end,
}

return Permissions
