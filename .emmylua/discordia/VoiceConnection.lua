---@class VoiceConnection

-- [[VoiceConnection Fields]] --

---@field channel GuildVoiceChannel|nil

local VoiceConnection = {
    -- [[VoiceConnection Methods]] --

    ---Stops the audio stream for this connection (if one is active), disconnects from the voice server, and leaves the corresponding voice channel.
    ---This method must be called inside of a coroutine, as it will yield until the stream is actually stopped.
    ---@param self VoiceConnection
    close = function(self) end,

    ---Returns the bitrate of the internal encoder in bits per second.
    ---@param self VoiceConnection
    ---@return nil
    getBitrate = function(self) end,

    ---Returns the complexity of the internal Opus encoder.
    ---@param self VoiceConnection
    ---@return number
    getComplexity = function(self) end,

    ---Temporarily pauses the audio stream for this connection, if one is active.
    ---This method must be called inside of a coroutine, as it will yield until the stream is actually stopped.
    ---@param self VoiceConnection
    pauseStream = function(self) end,

    ---Plays audio over the established connection using an FFMpeg process, assuming FFmpeg is properly configured.
    ---If `duration` is provided, the audio stream will play until that duration (in milliseconds) has elapsed.
    ---Otherwise, it will play until the source is exhausted.
    ---
    ---The returned number is the time elapsed while streaming and the returned string is a message detailing the reason why the stream stopped.
    ---See [this page](https://github.com/SinisterRectus/Discordia/wiki/Voice) for more details.
    ---@param self VoiceConnection
    ---@param path string
    ---@param duration number
    ---@return number
    ---@return string
    playFFmpeg = function(self, path, duration) end,

    ---Plays PCM data of the established connection. If `duration` is provided, the audio stream will play until that duration (in milliseconds) has elapsed.
    ---Otherwise, it will play until the source is exhausted.
    ---
    ---The returned number is the time elapsed while streaming and the returned string is a message detailing the reason why the stream stopped.
    ---See [this page](https://github.com/SinisterRectus/Discordia/wiki/Voice) for more details.
    ---@param self VoiceConnection
    ---@param source string|function|table|userdata
    ---@param duration number
    ---@return number
    ---@return string
    playPCM = function(self, source, duration) end,

    ---Resumes the audio stream for this connection, if one is active and paused.
    ---This method must be called inside of a coroutine, as it will yield until the stream is actually stopped.
    ---@param self VoiceConnection
    resumeStream = function(self) end,

    ---Sets the bitrate of the internal Opus encoder in bits per second. This should be 8000 at minimum.
    ---The max value depends upon the Guild the connection is attached to.
    ---@param self VoiceConnection
    ---@param bitrate number
    setBitrate = function(self, bitrate) end,

    ---Sets the complexity of the internal Opus encoder. This should be in the range [0, 10].
    ---@param self VoiceConnection
    ---@param complexity number
    setComplexity = function(self, complexity) end,

    ---Irreversibly stops the audio stream for this connection, if one is active.
    ---This method must be called inside of a coroutine, as it will yield until the stream is actually stopped.
    ---@param self VoiceConnection
    stopStream = function(self) end,
}

return VoiceConnection