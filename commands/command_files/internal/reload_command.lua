local Commands = require("commands")

local name = "reloadcmd" -- Name of the command.

local permissions = {
    bot_owner = true, -- Whether only the bot owner can use this command.
    manage_server = false, -- Whether you must have `Manage Server` to use this command.
    moderator = false, -- Whether you must be manually given permission to use this command.
}

local run_perms = {  } -- List of permissions that are required to run the command

local signature = "reloadcmd [cmd]" -- Type signature of the command for help files.

-- Array of information about arguments for help files.
--eg: {false, "arg", "This is an argument."}, {true, "optionalArg", "This argument is optional"}
local args = {
    {false, "cmd", "The name of the command to reload"}
}

-- Description of each command for help files.
local description = [[
Reloads the command `cmd` from the file tree.]]

-- The code block that gets executed when the command is ran.
---@param guild Guild
---@param author User
---@param message Message
---@param args string[]
local function command(guild, author, message, args)
    if #args == 0 then
        message:reply("Expected a command name as an argument")
        return
    end
    local reloaded = Commands.reloadCommand(args[1])

    if reloaded then
        message:reply(string.format("Successfully reloaded command `%s`.", args[1]))
    else
        message:reply(string.format("Could not reload command `%s`.", args[1]))
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