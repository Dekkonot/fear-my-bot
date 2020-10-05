---@class Reaction

-- [[Container Fields]] --

---@field client Client
---@field parent Container|Client

-- [[Reaction Fields]] --

---@field count number
---@field emojiHash string
---@field emojiId SnowflakeId|nil
---@field emojiName string
---@field emojiURL string|nil
---@field me boolean
---@field message Message

local Reaction = {
    ---Returns `Reaction.emojiId` if the reaction is a custom emoji, or `Reaction.emojiName` if is not.
    ---@param self Reaction
    ---@return string
    __hash = function(self) end,

    ---Removes the reaction from the message.
    ---@param self Reaction
    ---@param id SnowflakeId
    ---@return boolean
    delete = function(self, id) end,

    ---Returns a newly constructed cache of all users that have used this reaction in its parent message. Only `limit` users will be returned, if it is provided.
    ---
    ---The cache will not be automatically updated via gateway events, but the internally referenced user objects **might** be updated.
    ---You must call this method again to guarantee that the objects are up to date.
    ---@param self Reaction
    ---@param limit number
    ---@return SecondaryCache
    getUsers = function(self, limit) end,

    ---Returns a newly constructed cache of all users that have used this reaction after the specified user in its parent message.  Only `limit` users will be returned, if it is provided.
    ---
    ---The cache will not be automatically updated via gateway events, but the internally referenced user objects **might** be updated.
    ---You must call this method again to guarantee that the objects are up to date.
    ---@param self Reaction
    ---@param id SnowflakeId
    ---@param limit number
    ---@return SecondaryCache
    getUsersAfter = function(self, id, limit) end,

    ---Returns a newly constructed cache of all users that have used this reaction before the specified user in its parent message.  Only `limit` users will be returned, if it is provided.
    ---
    ---The cache will not be automatically updated via gateway events, but the internally referenced user objects **might** be updated.
    ---You must call this method again to guarantee that the objects are up to date.
    ---@param self Reaction
    ---@param id SnowflakeId
    ---@param limit number
    ---@return SecondaryCache
    getUsersBefore = function(self, id, limit) end,
}

return Reaction