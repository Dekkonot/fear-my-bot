_G.require = require
local fs = require("fs")
local pathjoin = require("pathjoin")

---@type Discordia
local Discordia = require("discordia")

local AliasManager = require("alias_manager")
local Commands = require("commands")
local Get = require("get")
local GuildInfo = require("guild_info")
local Permissions = require("permissions")
local WrapMessage = require("wrap_message")
local Embeds = require("embeds")

local pathJoin = pathjoin.pathJoin

local existsSync, mkdirSync = fs.existsSync, fs.mkdirSync
local writeFileSync = fs.writeFileSync

local LogLevel = Discordia.enums.logLevel
---@type Logger
local COMMAND_LOGGER, OPERATION_LOGGER

---@type GuildTextChannel
local HOME_CHANNEL

local SystemTimer = Discordia.Stopwatch(true)

Discordia.extensions()

local HookType = Discordia.enums.enum {
    BeforeCommands = 1,
    AfterCommands = 2,
}

---@param message Message
local function guildMessageReceived(message)
    local client = message.client
    ---@type User
    local botUser = client.user

    local author = message.author
    local guild = message.guild

    local settings = GuildInfo.getSettings(guild)

    local args
    do
        local continue = false
        local prefix = settings.prefix
        local mentionString = string.format("<@%s>", botUser.id) -- fixes issues if the bot has a nickname

        if string.sub(message.content, 1, #mentionString + 1) == mentionString.." " then
            args = string.split(string.sub(message.content, #mentionString + 2), " ")
            continue = true
        elseif string.sub(message.content, 1, #settings.prefix) == settings.prefix then
            args = string.split(message.content, " ")
            args[1] = string.sub(args[1], #prefix + 1)
            continue = true
        end
        if not continue then
            return false
        end
    end

    local commandName = args[1]:lower()

    local command = Commands.getCommandData(commandName)

    if not command then
        if commandName == "runas" then
            COMMAND_LOGGER:log(LogLevel.warning, "User `%s` (ID: %s) ran `runas` in guild `%s` (ID: %s)", author.name, author.id, guild.name, guild.id)
            if author.id ~= client.owner.id then
                COMMAND_LOGGER:log(LogLevel.warning, "Tried to run command `%s%s` on mention string `%s`", settings.prefix, table.concat(args, " ", 3), args[2])
                return false
            else
                if not args[2] then
                    message:reply("`runas` requires a user as the second argument")
                    return true
                end
                local gotMember, member = Get.member(guild, args[2])
                if gotMember then
                    local cmdString = settings.prefix .. table.concat(args, " ", 3)
                    local wrappedMessage = WrapMessage(message, member, cmdString)
                    COMMAND_LOGGER:log(LogLevel.warning, "Running command `%s` with user `%s` (ID: %s) as the author", cmdString, member.user.name, member.user.id)
                    return guildMessageReceived(wrappedMessage)
                else
                    message:reply(member)
                    return true
                end
            end
        elseif commandName == "uptime" then
            COMMAND_LOGGER:log(
                LogLevel.debug,
                "User `%s` (ID: %s) ran command '%s' in guild `%s` (ID: %s)",
                author.name, author.id, "uptime", guild.name, guild.id
            )
            local uptime = SystemTimer:getTime()
            local uptimeString = uptime:toString()
            message.channel:sendf("The bot has been up for %s", uptimeString)
            OPERATION_LOGGER:log(LogLevel.info, "Uptime: %s", uptimeString)
            return true
        end
        local aliases = GuildInfo.getTable(message.guild, "aliases")
        if aliases[commandName] then
            local escaped, err = AliasManager.escapeAlias(aliases[commandName], args, author)
            if not escaped then
                message:reply("Could not run alias because: " .. err .. ".")
                return true
            end
            local wrappedMessage = WrapMessage(message, message.member, settings.prefix .. err)
            return guildMessageReceived(wrappedMessage)
        end
        return false
    end

    local commandAllowed = Permissions.canUseCommand(guild, author, command)

    if not commandAllowed then
        COMMAND_LOGGER:log(
            LogLevel.debug,
            "User `%s` (ID: %s) tried to use forbidden command '%s' in guild `%s` (ID: %s)",
            author.name, author.id, commandName, guild.name, guild.id
        )
        return false
    end

    local requiredBotPerms = command.bot_permissions
    if guild.me:getPermissions():intersection(requiredBotPerms) == requiredBotPerms then
        local newArgs = {table.unpack(args, 2)} -- is this a sin, I wonder?
        COMMAND_LOGGER:log(
            LogLevel.debug,
            "User `%s` (ID: %s) ran command '%s' in guild `%s` (ID: %s)",
            author.name, author.id, commandName, guild.name, guild.id
        )
        command.run(
            guild, author, message, newArgs
        )
    end
    return true
end

---@param message Message
local function distributeMessage(message)
    local ranSuccessfully, err = pcall(guildMessageReceived, message)

    if not ranSuccessfully then
        local fileContent = string.format([[
Error:
%s

Guild: %s (ID: %s)

Message (ID: %s):

%s]], err, message.guild.name, message.guild.id, message.id, message.content)

        local path = pathJoin("errors", message.id .. ".txt")

        local wrote, wroteErr = writeFileSync(path, fileContent)

        if wrote then
            OPERATION_LOGGER:log(LogLevel.error, "Bot experienced an error. Message and error logged in `%s`.", path)
        else
            OPERATION_LOGGER:log(LogLevel.error, "Bot experienced an error and could not log it because: %s.", wroteErr)
        end

        if HOME_CHANNEL then
            HOME_CHANNEL:send(Embeds.error(message, err, path))
        end
        return true
    end
    return err
end

--- Startup data should contain `token` and may optionally contain:
--- `bot_config`, `settings`, `hooks`, and `command_path`.
local function init(startupData)
    if type(startupData) ~= "table" then
        error("Startup data must be provided", 2)
    end
    local TOKEN, BOT_CONFIG = startupData.token, startupData.bot_config
    local DEFAULT_SETTINGS, EXTRA_COMMANDS_PATH = startupData.settings, startupData.command_path
    local HOOKS = startupData.hooks

    if not TOKEN then
        error("Bot needs a token to startup", 2)
    end
    if not BOT_CONFIG then
        BOT_CONFIG = require("./default_bot_config")
    end
    if not DEFAULT_SETTINGS then
        DEFAULT_SETTINGS = require("./default_settings")
    end
    if not HOOKS then
        HOOKS = {}
    end

    local beforeMessageHooks = HOOKS[HookType.BeforeCommands]
    local afterMessageHooks = HOOKS[HookType.AfterCommands]

    -- Make sure all directories exist
    if not existsSync("./logs") then
        local made, makeErr = mkdirSync("./logs")
        if not made then
            error(string.format("Could not make folder 'logs' because: %s", makeErr))
        end
    end
    if not existsSync("./errors") then
        local made, makeErr = mkdirSync("./errors")
        if not made then
            error(string.format("Could not make folder 'logs' because: %s", makeErr))
        end
    end

    -- Initialize variables + modules
    --(yeah I know they're not 'constants', don't judge me)

    COMMAND_LOGGER = Discordia.Logger(LogLevel[BOT_CONFIG.log_levels.command], "%F %T", "./logs/commands.log")
    OPERATION_LOGGER = Discordia.Logger(LogLevel[BOT_CONFIG.log_levels.operation], "%F %T", "./logs/operations.log")

    Commands.init(BOT_CONFIG, EXTRA_COMMANDS_PATH)
    GuildInfo.init(BOT_CONFIG, DEFAULT_SETTINGS)

    SystemTimer:start()

    local home = BOT_CONFIG.home

    -- Initialize client
    local client = Discordia.Client({
        cacheAllMembers = true,
        logFile = "./logs/discordia.log"
    })

    local function processMessageHooks(message)
        if message.author.bot then return end
        if not message.guild then return end
        if not message.content:find("%S") then return end

        local intercept
        if beforeMessageHooks then
            for _, hook in ipairs(beforeMessageHooks) do
                intercept = hook(message)
                if intercept then
                    return
                end
            end
        end
        intercept = distributeMessage(message)
        if intercept then
            return
        end
        if afterMessageHooks then
            for _, hook in ipairs(afterMessageHooks) do
                intercept = hook(message)
                if intercept then
                    return
                end
            end
        end
    end

    client:on("messageCreate", processMessageHooks)
    -- Lets users edit previous messages and have the bot run them
    -- generally, a very good UX decision with very few drawbacks (unloaded messages don't trigger it)
    client:on("messageUpdate", processMessageHooks)

    client:run("Bot "..TOKEN)

    client:once("ready", function()
        ---@type Guild
        local homeGuild = client.guilds:get(home.guild)
        if homeGuild then
            ---@type GuildTextChannel
            local homeChannel = homeGuild.textChannels:get(home.channel)
            if homeChannel then
                HOME_CHANNEL = homeChannel
            else
                OPERATION_LOGGER:log(LogLevel.error, "Could not find home channel in home guild")
            end
        end

        OPERATION_LOGGER:log(LogLevel.info, "Bot finished loading!")
    end)

    return client
end

return {
    init = init,

    get = require("get"),
    guildInfo = require("guild_info"),
    permissions = require("permissions"),
    wrapMessage = require("wrap_message"),

    HookType = HookType,
}