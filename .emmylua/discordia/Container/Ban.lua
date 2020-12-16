---@class Ban
---@field client Client
---@field parent Container|Client
---@field guild Guild
---@field reason string|nil
---@field user User

local Ban = {
    -- [[Ban Methods]] --

    ---Returns `Ban.user.id`.
    ---@param self Ban
    ---@return SnowflakeId
    __hash = function(self) end,

    ---Deletes the ban object, unbanning the corresponding user.
    ---Equivalent to `Ban.guild:unbanUser(Ban.user)`.
    ---@param self Ban
    ---@return boolean
    delete = function(self) end,
}

return Ban