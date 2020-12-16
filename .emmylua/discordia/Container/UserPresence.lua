---@class UserPresence
---@field client Client
---@field parent Container|Client
---@field activity Activity|nil
---@field desktopStatus enums.status
---@field mobileStatus enums.status
---@field status enums.status
---@field user User
---@field webStatus enums.status

local UserPresence = {
    -- [[UserPresence Methods]] --

    ---Returns `UserPresence.user.id`.
    ---@param self UserPresence
    ---@return string
    __hash = function(self) end
}

return UserPresence