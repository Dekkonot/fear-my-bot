---@class uv_timer

local uv_timer = {
    -- [[uv_timer fields]] --

    ---Starts the timer. `timeout` and `repeatTime` are in milliseconds.
    ---
    ---If `timeout` is 0, the callback fires on the next event loop iteration.
    ---If `repeatTime` is non-zero, the callback fires first after `timeout` milliseconds then repeatedly after `repeat` milliseconds.
    ---@param self uv_timer
    ---@param timeout number
    ---@param repeatTime number
    ---@param callback function
    ---@return number|UV_FAIL
    start = function(self, timeout, repeatTime, callback) end,

    ---Stops the timer.
    ---@param self uv_timer
    ---@return number|UV_FAIL
    stop = function(self) end,

    ---Stops the timer, and if it is repeating, restarts it using the `repeatTime` as the timeout.
    ---If the timeout has not been started before, it will raise `EINVAL`.
    ---@param self uv_timer
    ---@return number|UV_FAIL
    again = function(self) end,

    ---Sets the repeat interval value in milliseconds.
    ---The timer will be schedules to run on the given interval, regardless of the callback execution duration,
    ---and will follow normal timer semantics in the case of a time-slice overrun.
    ---@param self uv_timer
    ---@param repeatTime number
    set_repeat = function(self, repeatTime) end,

    ---Gets the timer's repeat value.
    ---@param self uv_timer
    ---@return number
    get_repeat = function(self) end,
}

return uv_timer