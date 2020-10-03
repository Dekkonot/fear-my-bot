_G.require = require -- Necessary so that Luvit's require works in other modules
package.path = "modules/?.lua;?/init.lua;"..package.path

local fs = require("fs")

---@type Discordia
local Discordia = require("discordia")

local Commands = require("commands")
local Get = require("get")
local GuildInfo = require("guild_info")
local Permissions = require("permissions")
local WrapMessage = require("wrap_message")

local BOT_CONFIG = require("bot_config")
local BOT_USER

local Client = Discordia.Client({
    cacheAllMembers = true,
    logFile = "logs/discordia.log"
})

local LogLevel = Discordia.enums.logLevel
local CommandLogger = Discordia.Logger(LogLevel[BOT_CONFIG.log_levels.command], "%F %T", "logs/commands.log")
local OperationLogger = Discordia.Logger(LogLevel[BOT_CONFIG.log_levels.operation], "%F %T", "logs/operations.log")

local SystemTimer = Discordia.Stopwatch(true)

Discordia.extensions()

local function guildMessageReceived(message)
    local author = message.author
    local guild = message.guild

    local settings = GuildInfo.getSettings(guild)

    local args
    do
        local continue = false
        local prefix = settings.prefix
        local mentionString = BOT_USER.mentionString

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
            CommandLogger:log(LogLevel.warning, "User `%s` (ID: %s) ran `runas` in guild `%s` (ID: %s)", author.name, author.id, guild.name, guild.id)
            if author.id ~= Client.owner.id then
                CommandLogger:log(LogLevel.warning, "Tried to run command `%s%s` on mention string `%s`", settings.prefix, table.concat(args, " ", 3), args[2])
            else
                if not args[2] then
                    message:reply("`runas` requires a user as the second argument")
                    return
                end
                local gotMember, member = Get.member(guild, args[2])
                if gotMember then
                    local cmdString = settings.prefix .. table.concat(args, " ", 3)
                    local wrappedMessage = WrapMessage(message, member, cmdString)
                    CommandLogger:log(LogLevel.warning, "Running command `%s` with user `%s` (ID: %s) as the author", cmdString, member.user.name, member.user.id)
                    guildMessageReceived(wrappedMessage)
                else
                    message:reply(member)
                end
            end
            return
        elseif commandName == "uptime" then
            CommandLogger:log(
                LogLevel.debug,
                "User `%s` (ID: %s) ran command '%s' in guild `%s` (ID: %s)",
                author.name, author.id, "uptime", guild.name, guild.id
            )
            local uptime = SystemTimer:getTime()
            local uptimeString = uptime:toString()
            message.channel:sendf("The bot has been up for %s", uptimeString)
            OperationLogger:log(LogLevel.info, "Uptime: %s", uptimeString)
            return
        end
        return
    end

    local commandAllowed = Permissions.canUseCommand(guild, author, command)

    if not commandAllowed then
        CommandLogger:log(
            LogLevel.debug,
            "User `%s` (ID: %s) tried to use forbidden command '%s' in guild `%s` (ID: %s)",
            author.name, author.id, commandName, guild.name, guild.id
        )
        return
    end

    local requiredBotPerms = command.bot_permissions
    if guild.me:getPermissions():intersection(requiredBotPerms) == requiredBotPerms then
        table.remove(args, 1)
        CommandLogger:log(
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
    if message.content:trim() == "" then return end

    if not message.guild then
        return --! Temptation is to allow non-guild messages via virtual server, but that's outside of scope
    end

    guildMessageReceived(message)
end

local function startup()
    SystemTimer:start()

    Commands.init()
    GuildInfo.init()

    BOT_USER = Client.user
    OperationLogger:log(LogLevel.info, "Bot ready!")
end

Client:once("ready", startup)

Client:on("messageCreate", distributeMessage)

do
    local token, err = fs.readFileSync(BOT_CONFIG.token_file_name)
    if not token then
        error(string.format("Could not read file '%s' because: %s", BOT_CONFIG.token_file_namem, err))
    end
    Client:run("Bot "..token)
end