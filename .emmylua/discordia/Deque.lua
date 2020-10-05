---@class Deque

local Deque = {
    -- [[Deque Methods]] --

    ---Returns the total number of values in the deque.
    ---@param self Deque
    ---@return number
    getCount = function(self) end,

    ---Returns an iterator that returns all contained values from left to right.
    ---@param self Deque
    ---@return function
    iter = function(self) end,

    ---Returns the value at the left side of the deque without removing it.
    ---@param self Deque
    ---@return any
    peekLeft = function(self) end,

    ---Returns the value at the right side of the deque without removing it.
    ---@param self Deque
    ---@return any
    peekRight = function(self) end,

    ---Removes and returns the value at the left side of the deque.
    ---@param self Deque
    ---@return any
    popLeft = function(self) end,

    ---Removes and returns the value at the right side of the deque.
    ---@param self Deque
    ---@return any
    popRight = function(self) end,

    ---Adds a value of any type to the left side of the deque.
    ---@param self Deque
    ---@param value any
    ---@return any
    pushLeft = function(self, value) end,

    ---Adds a value of any type to the right side of the deque.
    ---@param self Deque
    ---@param value any
    ---@return any
    pushRight = function(self, value) end,
}

return Deque