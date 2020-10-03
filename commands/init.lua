local fs = require("fs")
local pathjoin = require("pathjoin")

local Discordia = require("discordia")

local BOT_CONFIG = require("bot_config")

local pathJoin = pathjoin.pathJoin
local readdirSync, lstatSync, existsSync =  fs.readdirSync, fs.lstatSync, fs.existsSync

local LogLevel = Discordia.enums.logLevel
local CommandLogger = Discordia.Logger(LogLevel[BOT_CONFIG.log_levels.command], "%F %T", "logs/commands.log")

local BASE_PERMISSION_OBJECT = Discordia.Permissions.fromMany("readMessages", "sendMessages", "readMessageHistory")

local COMMAND_FILE_PATH = pathJoin("commands", "command_files")

local OPTIONAL_ARG_STRING = " (this argument is optional)"
local ARG_STRING = "`%s` - %s%s"

local initialized = false

local commandMap = {}
local requiredCommandPerms = {}

local commandCount = 0

local function processCommandData(data, path)
    local cmdPerms = BASE_PERMISSION_OBJECT:copy()
    for _, perm in ipairs(data.run_perms) do
        cmdPerms:enable(perm)
    end

    local argList = {}
    for i, argData in ipairs(data.args) do
        argList[i] = string.format(ARG_STRING, argData[2], argData[3], argData[1] and OPTIONAL_ARG_STRING or "")
    end

    local commandName = data.name

    local user_perms = data.permissions

    ---@class Command
    local commandData = {
        user_permissions = {
            ---@type boolean
            bot_owner = user_perms.bot_owner,
            ---@type boolean
            manage_server = user_perms.manage_server,
            ---@type boolean
            moderator = user_perms.moderator,
            ---@type boolean
            fluff = user_perms.fluff,
        },
        ---@type Permissions
        bot_permissions = cmdPerms,

        ---@type string
        name = commandName,
        ---@type string
        signature = data.signature,
        arguments = argList,
        ---@type string
        description = data.description,

        ---@type fun(guild:Guild,author:User,message:Message,args:string[]):nil
        run = data.command,

        _path = path,
    }

    commandCount = commandCount + 1

    commandMap[commandName] = commandData
    requiredCommandPerms[commandName] = cmdPerms
end

local function readAndProcessDir(dir)
    for _, fileName in ipairs(readdirSync(dir)) do
        local filePath = pathJoin(dir, fileName)
        local isFile = lstatSync(filePath).type == "file"
        if isFile then
            local commandData = dofile(filePath)
            processCommandData(commandData, filePath)
        else
            readAndProcessDir(filePath)
        end
    end
end

---Returns data about a given command, if it exists
---@param commandName string
---@return Command
local function getCommandData(commandName)
    if not initialized then
        error("Tried to use Commands module before initialization", 2)
    end
    return commandMap[commandName]
end

---Reloads a given command and returns whether or not it successfully reloaded.
---@param commandName string
---@return boolean
local function reloadCommand(commandName)
    if not initialized then
        error("Tried to use Commands module before initialization", 2)
    end
    ---@type Command
    local commandData = commandMap[commandName]
    if commandData then
        local path = commandData._path
        if existsSync(path) then
            CommandLogger:log(LogLevel.info, "Reloaded command '%s'", commandName)
            local newCommandData = dofile(path)
            processCommandData(newCommandData, path)
            return true
        end
    end
    CommandLogger:log(LogLevel.info, "Failed to reload command '%s'", commandName)
    return false
end

---Initializes the module and loads all the commands.
local function init()
    readAndProcessDir(COMMAND_FILE_PATH)

    CommandLogger:log(LogLevel.info, "Initialized commands")
    CommandLogger:log(LogLevel.info, "Loaded commands: %i", commandCount)
    initialized = true
end

return {
    init = init,

    commandMap = commandMap,

    getCommandData = getCommandData,
    reloadCommand = reloadCommand,
}