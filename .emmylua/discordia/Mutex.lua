---@class Mutex

local Mutex = {
    -- [[Mutex Methods]] --

    ---If the mutex is not currently active, this will activate the mutex.
    ---Otherwise, this will yield and queue the current coroutine.
    ---@param self Mutex
    ---@param prepend boolean
    lock = function(self, prepend) end,

    ---If the mutex is active, this will dequeue and resume the next available coroutine.
    ---Otherwise, this will deactivate the mutex.
    unlock = function(self) end,

    ---Asynchronously unlocks the mutex after a specified time in milliseconds.
    ---The relevant `uv_timer` object is returned.
    ---@param self Mutex
    ---@param delay number
    ---@return uv_timer
    unlockAfter = function(self, delay) end,
}

return Mutex