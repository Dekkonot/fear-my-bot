local prettyPrint = require("pretty-print")

local Discordia = require("Discordia")

local Commands = require("Commands")
local Embeds = require("embeds")
local Get = require("get")
local GuildInfo = require("guild_info")
local Permission = require("permissions")
local WrapMessage = require("wrap_message")

local prettyDump = prettyPrint.dump

local ENVIRONMENT_MT = {__index = function(_, index)
    return _G[index]
end}

local function execPrint(...)
    local arr = {...}
    for i = 1, select("#", ...) do
        arr[i] = tostring(select(i, ...))
    end

    return table.concat(arr, " ")
end

local function execPrettyPrint(...)
    local arr = {...}
    for i = 1, select("#", ...) do
        arr[i] = prettyDump(select(i, ...), true, true)
    end

    return table.concat(arr, " ")
end

local name = "exec" -- Name of the command.

local permissions = {
    bot_owner = true, -- Whether only the bot owner can use this command.
    manage_server = false, -- Whether you must have `Manage Server` to use this command.
    moderator = false, -- Whether you must be manually given permission to use this command.
}

local run_perms = { "attachFiles" } -- List of permissions that are required to run the command

local signature = "exec [chunk]" -- Type signature of the command for help files.

-- Array of information about arguments for help files.
--eg: {false, "arg", "This is an argument."}, {true, "optionalArg", "This argument is optional"}
local args = {
    {false, "chunk", "The Lua chunk to execute."}
}

-- Description of each command for help files.
local description = [[
Executes an arbitrary `chunk` of Lua code.]]

-- The code block that gets executed when the command is ran.
---@param guild Guild
---@param author User
---@param message Message
---@param args string[]
local function command(guild, author, message, args)
    local chunk = table.concat(args, " ")
    if chunk == "" then
        message:reply("Expected chunk, got empty string")
        return
    end

    local stdOut = {}
    local c = 1
    local outLen = 0

    local executor, compileErr = load(chunk, "exec", "t", setmetatable({
        Discordia = Discordia,
        Commands = Commands,
        Embeds = Embeds,
        Get = Get,
        GuildInfo = GuildInfo,
        Permission = Permission,
        WrapMessage = WrapMessage,
        guild = guild,
        author = author,
        message = message,

        print = function(...)
            local out = execPrint(...)
            outLen = outLen + #out + 1
            stdOut[c] = out
            c = c + 1
        end,
        p = function(...)
            local out = execPrettyPrint(...)
            outLen = outLen + #out + 1
            stdOut[c] = out
            c = c + 1
        end,
    }, ENVIRONMENT_MT))

    if not compileErr then
        local ran, runtimeErr = pcall(executor, compileErr)
        if not ran then
            message:reply(string.format("```\n%s\n```", runtimeErr))
        else
            if outLen > 2000 then
                message:reply({file = {"stdout.txt", table.concat(stdOut, "\n")}})
            elseif outLen + 8 > 2000 then
                message:reply(table.concat(stdOut, "\n"))
            else
                message:reply(string.format("```\n%s\n```", table.concat(stdOut, "\n")))
            end
        end
    else
        message:reply(string.format("```\n%s\n```", compileErr))
    end
end


return {
    name = name,

    permissions = permissions,
    run_perms = run_perms,

    signature = signature,
    args = args,
    description = description,

    command = command
}