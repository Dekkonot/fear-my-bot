_G.require = require -- Necessary so that Luvit's require works in other modules
package.path = "modules/?.lua;?/init.lua;"..package.path

local fs = require("fs")
local pathjoin = require("pathjoin")

---@type Discordia
local Discordia = require("discordia")

local Commands = require("commands")
local Get = require("get")
local GuildInfo = require("guild_info")
local Permissions = require("permissions")
local WrapMessage = require("wrap_message")

local BOT_CONFIG = require("bot_config")

local pathJoin = pathjoin.pathJoin

local existsSync, mkdirSync = fs.existsSync, fs.mkdirSync
local writeFileSync, readFileSync = fs.writeFileSync, fs.readFileSync

local LogLevel = Discordia.enums.logLevel
---@type Logger
local COMMAND_LOGGER = Discordia.Logger(LogLevel[BOT_CONFIG.log_levels.command], "%F %T", "logs/commands.log")
---@type Logger
local OPERATION_LOGGER = Discordia.Logger(LogLevel[BOT_CONFIG.log_levels.operation], "%F %T", "logs/operations.log")

---@type GuildTextChannel
local HOME_CHANNEL

local SystemTimer = Discordia.Stopwatch(true)

Discordia.extensions()

local function guildMessageReceived(message)
    local client = message.client
    local botUser = client.user

    local author = message.author
    local guild = message.guild

    local settings = GuildInfo.getSettings(guild)

    local args
    do
        local continue = false
        local prefix = settings.prefix
        local mentionString = botUser.mentionString

        if string.sub(message.content, 1, #mentionString + 1) == mentionString.." " then
            args = string.split(string.sub(message.content, #mentionString + 2), " ")
            continue = true
        elseif string.sub(message.content, 1, #settings.prefix) == settings.prefix then
            args = string.split(message.content, " ")
            args[1] = string.sub(args[1], #prefix + 1)
            continue = true
        end
        if not continue then return end
    end

    local commandName = args[1]:lower()

    local command = Commands.getCommandData(commandName)

    if not command then
        if commandName == "runas" then
            COMMAND_LOGGER:log(LogLevel.warning, "User `%s` (ID: %s) ran `runas` in guild `%s` (ID: %s)", author.name, author.id, guild.name, guild.id)
            if author.id ~= client.owner.id then
                COMMAND_LOGGER:log(LogLevel.warning, "Tried to run command `%s%s` on mention string `%s`", settings.prefix, table.concat(args, " ", 3), args[2])
            else
                if not args[2] then
                    message:reply("`runas` requires a user as the second argument")
                    return
                end
                local gotMember, member = Get.member(guild, args[2])
                if gotMember then
                    local cmdString = settings.prefix .. table.concat(args, " ", 3)
                    local wrappedMessage = WrapMessage(message, member, cmdString)
                    COMMAND_LOGGER:log(LogLevel.warning, "Running command `%s` with user `%s` (ID: %s) as the author", cmdString, member.user.name, member.user.id)
                    guildMessageReceived(wrappedMessage)
                else
                    message:reply(member)
                end
            end
            return
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
            return
        end
        return
    end

    local commandAllowed = Permissions.canUseCommand(guild, author, command)

    if not commandAllowed then
        COMMAND_LOGGER:log(
            LogLevel.debug,
            "User `%s` (ID: %s) tried to use forbidden command '%s' in guild `%s` (ID: %s)",
            author.name, author.id, commandName, guild.name, guild.id
        )
        return
    end

    local requiredBotPerms = command.bot_permissions
    if guild.me:getPermissions():intersection(requiredBotPerms) == requiredBotPerms then
        table.remove(args, 1)
        COMMAND_LOGGER:log(
            LogLevel.debug,
            "User `%s` (ID: %s) ran command '%s' in guild `%s` (ID: %s)",
            author.name, author.id, commandName, guild.name, guild.id
        )
        command.run(
            guild, author, message, args
        )
    end
end

---@param message Message
local function distributeMessage(message)
    if message.author.bot then return end
    if not message.content:find("%S") then return end

    if not message.guild then
        return --! Temptation is to allow non-guild messages via virtual server, but that's outside of scope
    end

    local ranSuccessfully, err = pcall(guildMessageReceived, message)

    if not ranSuccessfully then
        local fileContent = string.format([[
Error:
%s

Guild: %s (ID: %s)

Message:

%s]], err, message.guild.name, message.guild.id, message.content)

        local wrote, wroteErr = writeFileSync(pathJoin("errors", message.id), fileContent)

        if wrote then
            OPERATION_LOGGER:log(LogLevel.error, "Bot experienced an error. Message and error logged in `errors/%s`.", message.id)
        else
            OPERATION_LOGGER:log(LogLevel.error, "Bot experienced an error and could not log it because: %s.", wroteErr)
        end

        if HOME_CHANNEL then
            HOME_CHANNEL:send({
                content = string.format("Bot experienced an error. Message and error logged in `errors/%s`.", message.id),
                file = {
                    "error_"..message.id,
                    fileContent
                },
            })
        end
    end
end

local function init()
    -- Make sure all directories exist
    if not existsSync("logs") then
        local made, makeErr = mkdirSync("logs")
        if not made then
            error(string.format("Could not make folder 'logs' because: %s", makeErr))
        end
    end
    if not existsSync("errors") then
        local made, makeErr = mkdirSync("errors")
        if not made then
            error(string.format("Could not make folder 'logs' because: %s", makeErr))
        end
    end

    -- Initialize variables + modules
    --(yeah I know they're not 'constants', don't judge me)
    COMMAND_LOGGER = Discordia.Logger(LogLevel[BOT_CONFIG.log_levels.command], "%F %T", "logs/commands.log")
    OPERATION_LOGGER = Discordia.Logger(LogLevel[BOT_CONFIG.log_levels.operation], "%F %T", "logs/operations.log")

    Commands.init()
    GuildInfo.init()

    SystemTimer:start()

    -- Read token file
    local token, err = readFileSync(BOT_CONFIG.token_file_name)
    if not token then
        error(string.format("Could not read file '%s' because: %s", BOT_CONFIG.token_file_name, err))
    end

    local home = BOT_CONFIG.home

    -- Initialize client
    local client = Discordia.Client({
        cacheAllMembers = true,
        logFile = "logs/discordia.log"
    })

    client:on("messageCreate", distributeMessage)

    client:run("Bot "..token)

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
    end)
end

init()