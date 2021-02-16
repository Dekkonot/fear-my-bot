local Commands = require("commands")
local Embeds = require("embeds")
local Permissions = require("permissions")

local name = "help" -- Name of the command.

local permissions = {
    bot_owner = false, -- Whether only the bot owner can use this command.
    manage_server = false, -- Whether you must have `Manage Server` to use this command.
    moderator = false, -- Whether you must be manually given permission to use this command.
}

local run_perms = {"embedLinks"} -- List of permissions that are required to run the command

local signature = "help <command>" -- Type signature of the command for help files.

-- Array of information about arguments for help files.
--eg: {false, "arg", "This is an argument."}, {true, "optionalArg", "This argument is optional"}
local args = {
    {true, "command", "A command to provide more specific help for"}
}

-- Description of each command for help files.
local description = [[
Provides information on how to use the bot.

If `command` is provided, information on a specific command will be given. Otherwise, a list of all commands available will be given, along with basic usage information.
]]

-- The code block that gets executed when the command is ran.
---@param guild Guild
---@param author User
---@param message Message
---@param args string[]
local function command(guild, author, message, args)
    if #args == 0 then
        message:reply(Embeds.help(guild, author))
    else
        local commandName = args[1]:lower()
        local commandData = Commands.commandMap[commandName]
        if commandData then
            if Permissions.canUseCommand(guild, author, commandData) then
                message:reply(Embeds.commandHelp(guild, commandData))
            end
        elseif commandName == "runas" then
            if guild.client.owner.id == author.id then
                message:reply(Embeds.commandHelp(guild, {
                    user_permissions = {
                        bot_owner = true,
                        manage_server = false,
                        moderator = false,
                    },
                    description = "Runs a command as another user.",
                    signature = "runas [user] [command]",
                    arguments = {
                        "`user` - The user to run the command as",
                        "`command` - The command to run (without the prefix)"
                    },
                }))
            end
        elseif commandName == "uptime" then
            message:reply(Embeds.commandHelp(guild, {
                user_permissions = {
                    bot_owner = false,
                    manage_server = false,
                    moderator = false,
                },
                description = "Sends a message indicating how long the bot has been running.",
                signature = "uptime",
                arguments = {},
            }))
        end
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