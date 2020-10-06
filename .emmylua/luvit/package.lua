---@class LuvitPackage

---@field name string
---@field version string
---@field description string
---@field tags string[]
---@field license string
---@field homepage string
---@field dependencies string[]
---@field files string[]

local package = {
    author = {
        ---@type string
        name = nil,
        ---@type string
        email = nil,
    }
}

return package