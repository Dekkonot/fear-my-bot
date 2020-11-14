local fs = require("fs")
local pathjoin = require("pathjoin")

---@type Discordia
local Discordia = require("discordia")
local json = require("json")

local BOT_CONFIG
local SETTINGS_MT

local GUILD_DATA_DIR = "guild_data"

local LogLevel = Discordia.enums.logLevel
---@type Logger
local GUILD_INFO_LOGGER

local Clock = Discordia.Clock()

local pathJoin = pathjoin.pathJoin

local existsSync, mkdirSync = fs.existsSync, fs.mkdirSync
local writeFileSync, readFileSync = fs.writeFileSync, fs.readFileSync

local guildInfoCache = {} -- For caching the guild info
local lastRequest = {} -- For keeping track of how many minutes have passed since the last request from a guild

local function checkAndMakeDir(name)
    if existsSync(name) then
        GUILD_INFO_LOGGER:log(LogLevel.debug, "Checked if directory '%s' exists", name)
    else
        mkdirSync(name)
        GUILD_INFO_LOGGER:log(LogLevel.info, "Created directory '%s'", name)
    end
end

---Gets a saved table for a guild.
---@param guild Guild
---@param name string
---@return table
local function getTable(guild, name)
    local id = guild.id

    GUILD_INFO_LOGGER:log(LogLevel.debug, "Getting table '%s' for guild `%s` (ID: %s)", name, guild.name, id)

    lastRequest[id] = BOT_CONFIG.gc_info.max_guild_info_cache

    local cache = guildInfoCache[id]
    if not cache then
        cache = {}
        guildInfoCache[id] = cache
        checkAndMakeDir(pathJoin(GUILD_DATA_DIR, id))
    end
    local guildTable = cache[name]
    if not guildTable then
        local fileName = pathJoin(GUILD_DATA_DIR, id, name) .. ".json"
        if existsSync(fileName) then
            local contents, err = readFileSync(fileName)
            if not contents then
                GUILD_INFO_LOGGER:log(LogLevel.error, "Guild table '%s' couldn't be read because: %s", name, err)
                guildTable = {}
                cache[name] = guildTable
            else
                GUILD_INFO_LOGGER:log(LogLevel.debug, "Read guild table '%s'", name)
                local parsed = json.decode(contents)
                guildTable = parsed
                cache[name] = parsed
            end
        else
            GUILD_INFO_LOGGER:log(LogLevel.debug, "Guild table '%s' didn't exist", name)
            guildTable = {}
            cache[name] = guildTable
        end
    else
        setmetatable(guildTable, nil) -- consequence of caching is that we have to deal with MTs.
    end
    return guildTable
end

---Sets a table for a guild. Whether the table saved successfully is returned.
---@param guild Guild
---@param name string
---@param newTable table
---@return boolean
local function setTable(guild, name, newTable)
    local id = guild.id

    GUILD_INFO_LOGGER:log(LogLevel.debug, "Setting table '%s' for guild `%s` (ID: %s)", name, guild.name, id)

    setmetatable(newTable, nil)

    local stringified = json.encode(newTable)
    if not stringified then
        GUILD_INFO_LOGGER:log(LogLevel.error, "Failed to stringify table '%s'", name)
        return false
    end

    local cache = guildInfoCache[id]
    if cache then
        local guildTable = cache[name]
        if guildTable then
            GUILD_INFO_LOGGER:log(LogLevel.debug, "Updated cache for table '%s'", name)
            cache[name] = newTable
        end
    end

    checkAndMakeDir(pathJoin(GUILD_DATA_DIR, id))

    -- I am optimistically assuming LibUV locks files so we don't need a mutex
    local wrote, err = writeFileSync(pathJoin(GUILD_DATA_DIR, id, name) .. ".json", stringified)

    if not wrote then
        GUILD_INFO_LOGGER:log(LogLevel.error, "Guild table '%s' couldn't be written because: %s", name, err)
        return false
    end

    return true
end

---Gets and returns the settings table for a guild.
---@param guild Guild
---@return table
local function getSettings(guild)
    local settings = getTable(guild, "settings")

    setmetatable(settings, SETTINGS_MT)

    return settings
end

---Saves a guild's settings table. Whether it saved successfully is returned.
---@param guild Guild
---@param settings table
---@return boolean
local function setSettings(guild, settings)
    return setTable(guild, "settings", settings)
end

---Purges the cache for a guild, or optionally purges a specific table from the cache.
---@param guild SnowflakeId
---@param name string
local function purgeCache(guild, name)
    local cache = guildInfoCache[guild]
    if cache then
        if name then
            cache[name] = nil
        else
            guildInfoCache[guild] = nil
            lastRequest[guild] = nil
        end
    end
end

local function decrementLastRequst()
    for id, remainingTime in pairs(lastRequest) do
        remainingTime = remainingTime - 1
        if remainingTime <= 0 then
            GUILD_INFO_LOGGER:log(LogLevel.debug, "Purged guild '%s' from cache", id)
            guildInfoCache[id] = nil
        end
    end
end

---Initializes the mdoule and starts the internal decrement timer.
local function init(botConfig, settings)
    BOT_CONFIG = botConfig
    SETTINGS_MT = {
        __index = settings
    }

    GUILD_INFO_LOGGER = Discordia.Logger(
        LogLevel[BOT_CONFIG.log_levels.file],
        "%F %T",
        "../logs/guild_info.log"
    )

    checkAndMakeDir("guild_data")

    Clock:on("min", decrementLastRequst)

    Clock:start()

    GUILD_INFO_LOGGER:log(LogLevel.info, "Initialized GuildInfo")
    GUILD_INFO_LOGGER:log(LogLevel.info, "Cache max life: %i", BOT_CONFIG.gc_info.max_guild_info_cache)
end

return {
    init = init,

    getTable = getTable,
    setTable = setTable,

    getSettings = getSettings,
    setSettings = setSettings,

    purgeCache = purgeCache,
}