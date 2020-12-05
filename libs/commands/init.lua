local fs = require("fs")
local pathjoin = require("pathjoin")

---@type Discordia
local Discordia = require("discordia")

local pathJoin = pathjoin.pathJoin
local readdirSync, readFileSync = fs.readdirSync, fs.readFileSync
local lstatSync, existsSync = fs.lstatSync, fs.existsSync

local LogLevel = Discordia.enums.logLevel
---@type Logger
local COMMAND_LOGGER

---@type Permissions
local BASE_PERMISSION_OBJECT = Discordia.Permissions.fromMany("readMessages", "sendMessages", "readMessageHistory")

local OPTIONAL_ARG_STRING = " (this argument is optional)"
local ARG_STRING = "`%s` - %s%s"

local initialized = false

local commandMap = {}
local requiredCommandPerms = {}

local commandCount = 0

local function processExternalCommand(data, path)
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
        _internal = false
    }

    commandCount = commandCount + 1

    commandMap[commandName] = commandData
    requiredCommandPerms[commandName] = cmdPerms
end

local function processInternalCommand(data, path)
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

    ---@type Command
    local commandData = {
        user_permissions = {
            bot_owner = user_perms.bot_owner,
            manage_server = user_perms.manage_server,
            moderator = user_perms.moderator,
            fluff = user_perms.fluff,
        },
        bot_permissions = cmdPerms,

        name = commandName,
        signature = data.signature,
        arguments = argList,
        description = data.description,

        run = data.command,

        _path = path,
        _internal = true
    }

    commandCount = commandCount + 1

    commandMap[commandName] = commandData
    requiredCommandPerms[commandName] = cmdPerms
end

local function readFile(filePath)
    -- I miss Rust.
    local fileContent, readError = readFileSync(filePath)
    if not fileContent then
        return false, string.format("could not read command '%s' because: %s", filePath, readError)
    end
    local chunk, compileError = load(fileContent, string.format("command %s", filePath), "t", _G)
    if not chunk then
        return false, string.format("could not compile command '%s' because: %s", filePath, compileError)
    end
    local ran, commandData = pcall(chunk)
    if not ran then
        return false, string.format("could not load command '%s' because: %s", filePath, commandData)
    end
    return true, commandData
end

local function readAndProcessDir(dir)
    if not existsSync(dir) then
        error(string.format("directory '%s' does not exist", dir), 2)
    end
    COMMAND_LOGGER:log(LogLevel.debug, "Loading command directory '%s'", dir)

    for _, fileName in ipairs(readdirSync(dir)) do
        fileName = pathJoin(dir, fileName)
        local isFile = lstatSync(fileName).type == "file"
        if isFile then
            COMMAND_LOGGER:log(LogLevel.debug, "Reading file '%s'", fileName)
            local read, commandData = readFile(fileName)
            if not read then
                error(commandData, 2)
            end
            processExternalCommand(commandData, fileName)
        else
            readAndProcessDir(fileName)
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
        local internal = commandData._internal
        if internal then
            package.loaded[path] = nil
            processInternalCommand(require(path), path)
            COMMAND_LOGGER:log(LogLevel.info, "Reloaded command '%s'", commandName)
            return true
        else
            if existsSync(path) then
                local newCommandData = load(path)
                COMMAND_LOGGER:log(LogLevel.info, "Reloaded command '%s'", commandName)
                processExternalCommand(newCommandData, path)
                return true
            end
        end
    end
    COMMAND_LOGGER:log(LogLevel.info, "Failed to reload command '%s'", commandName)
    return false
end

---Initializes the module and loads all the commands.
local function init(botConfig, extraCommandsPath)
    COMMAND_LOGGER = Discordia.Logger(LogLevel[botConfig.log_levels.command], "%F %T", "../logs/commands.log")

    COMMAND_LOGGER:log(LogLevel.debug, "Loading internal commands")
    local rawCommandData = require("commands/command_files")
    for _, data in pairs(rawCommandData) do
        processInternalCommand(data[1], data[2])
    end

    if extraCommandsPath then
        COMMAND_LOGGER:log(LogLevel.debug, "Loading extra commands")
        readAndProcessDir(extraCommandsPath)
    end

    COMMAND_LOGGER:log(LogLevel.info, "Initialized commands")
    COMMAND_LOGGER:log(LogLevel.info, "Loaded commands: %i", commandCount)
    initialized = true
end

return {
    init = init,

    commandMap = commandMap,

    getCommandData = getCommandData,
    reloadCommand = reloadCommand,
}