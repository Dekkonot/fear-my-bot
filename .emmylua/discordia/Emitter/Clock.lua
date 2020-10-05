---@class Clock

local Clock = {
    -- [[Emitter Methods]] --

    ---Emits the named event and a variable number of arguments to pass to the event callback.
    ---@param self Emitter
    ---@param name string
    emit = function(self, name, ...) end,

    ---Returns the number of callbacks registered to the named event.
    ---@param self Emitter
    ---@param name string
    ---@return number
    getListenerCount = function(self, name) end,

    ---Returns an iterator for all callbacks registered to the named event.
    ---@param self Emitter
    ---@param name string
    ---@return function
    getListeners = function(self, name) end,

    ---Subscribes `callback` to be called every time the named event is emmited.
    ---Callbacks registered with this method will be automatically wrapped as a new coroutine when they are called.
    ---Returns the original callback.
    ---@param self Emitter
    ---@param name string
    ---@param callback function
    ---@return function
    on = function(self, name, callback) end,

    ---Subscribes `callback` to be called every time the named event is emmited.
    ---Callbacks registered with this method will **not** be wrapped as a new coroutine when they are called.
    ---Returns the original callback.
    ---@param self Emitter
    ---@param name string
    ---@param callback function
    ---@return function
    onSync = function(self, name, callback) end,

    ---Subscribes `callback` to be called only the next time the named event is emmited.
    ---Callbacks registered with this method will be wrapped as a new coroutine when they are called.
    ---Returns the original callback.
    ---@param self Emitter
    ---@param name string
    ---@param callback function
    ---@return function
    once = function(self, name, callback) end,

    ---Subscribes `callback` to be called only the next time the named event is emmited.
    ---Callbacks registered with this method will **not** be wrapped as a new coroutine when they are called.
    ---Returns the original callback.
    ---@param self Emitter
    ---@param name string
    ---@param callback function
    ---@return function
    onceSync = function(self, name, callback) end,

    ---Unregistered all callbacks for the emitter.
    ---If `name` is passed, then only callbacks for that event are unregistered.
    ---@param self Emitter
    ---@param name string
    removeAllListeners = function(self, name) end,

    ---Unregisters all instances of the callback from the named event.
    ---@param name string
    ---@param callback function
    removeListener = function(name, callback) end,

    ---Yields the current coroutine until the named event is emitted.
    ---If a timeout (in milliseconds) is provided, the function will resume after that time regardless of if the event has been emitted and `false` will be returned.
    ---Otherwise, `true` will be returned.
    ---If a predicate is provided, events that do not satisfy it will be ignored.
    ---@param self Emitter
    ---@param name string
    ---@param timeout number
    ---@param predicate function
    ---@return boolean
    waitFor = function(self, name, timeout, predicate) end,

    -- [[Clock Methods]] --

    ---Starts the main loop for the clock.
    ---If `boolean` is true, then UTC time is used for the clock. Otherwise, it uses local time.
    ---
    ---As the clock ticks, an event is emitted for every `os.date` value change.
    ---The event name is the key of the value that changed and the event argument is the corresponding value.
    ---@param self Clock
    ---@param utc boolean
    start = function(self, utc) end,

    ---Stops the main loop for the clock.
    ---@param self Clock
    stop = function(self) end,
}

return Clock