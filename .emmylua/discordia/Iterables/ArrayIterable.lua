---@class ArrayIterable
---@field first any
---@field last any

local ArrayIterable = {
    -- [[Iterable Methods]] --

    ---If `predicate` is provided, this returns the number of objects in the iterable that satisfy it.
    ---Otherwise, returns the total number of objects in the iterable.
    ---@param self Iterable
    ---@param predicate function
    ---@return number
    count = function(self, predicate) end,

    ---Returns the first object that satisfy `predicate`.
    ---@param self Cache
    ---@param predicate function
    ---@return any
    find = function(self, predicate) end,

    ---Returns an iterator that returns all objects that satisfy `predicate`.
    ---@param self Iterable
    ---@param predicate function
    ---@return function
    findAll = function(self, predicate) end,

    ---Iterates through all objects and calls `fn` on each one.
    ---@param self Guild
    ---@param fn function
    forEach = function(self, fn) end,

    ---Returns an individual object by key, where key should match the result of calling `__hash` on the contain objects.
    ---@param self Iterable
    ---@param k SnowflakeId|string
    get = function(self, k) end,

    ---Returns an iterator that returns the values from each encountered object picked by the provided keys.
    ---If a key is a string, the objects are indexed with the string. If a key is a function, the function is called on the object.
    ---@param self Iterable
    ---@return function
    pick = function(self, ...) end,

    ---Picks a random object that is contained in the iterable.
    ---@param self Iterable
    ---@return any
    random = function(self) end,

    ---Similiar to an SQL query, returns a sorted Lua table of rows, where each row corresponds to each object in the iterable,
    ---And each value in the row is selected from the objects according to the keys provided.
    ---@param self Iterable
    select = function(self, ...) end,

    ---Returns a sequentially-indexed table that contains references to all objects.
    ---If `sortBy` is provided, then the table is sorted by that particular property.
    ---If `predicate` is provided, only objects that satisify it will be included.
    ---@param self Iterable
    ---@param sortBy string
    ---@param predicate function
    ---@return any[]
    toArray = function(self, sortBy, predicate) end,

    -- [[ArrayIterable Methods]] --

    ---Returns an iterator for all contained objects in a consistent order.
    ---@param self ArrayIterable
    ---@return function
    iter = function(self) end,
}

return ArrayIterable