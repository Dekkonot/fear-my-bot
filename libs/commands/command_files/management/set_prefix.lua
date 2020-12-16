local GuildInfo = require("guild_info")

local name = "setprefix" -- Name of the command.

local permissions = {
    bot_owner = false, -- Whether only the bot owner can use this command.
    manage_server = false, -- Whether you must have `Manage Server` to use this command.
    moderator = false, -- Whether you must be manually given permission to use this command.
}

local run_perms = {  } -- List of permissions that are required to run the command

local signature = "prefix [newPrefix]" -- Type signature of the command for help files.

-- Array of information about arguments for help files.
--eg: {false, "arg", "This is an argument."}, {true, "optionalArg", "This argument is optional"}
local args = {
    {false, "newPrefix", "The new prefix for the bot"}
}

-- Description of each command for help files.
local description = [[
Sets the prefix for the bot in this guild. The bot also responds to mentions.]]

-- The code block that gets executed when the command is ran.
---@param guild Guild
---@param author User
---@param message Message
---@param args string[]
local function command(guild, author, message, args)
    if #args == 0 then
        message:reply("You must specify a prefix.")
    elseif not args[1]:find("%S") then
        message:reply("The prefix must not be whitespace.")
    else
        local settings = GuildInfo.getSettings(guild)
        settings.prefix = args[1]
        local success = GuildInfo.setSettings(guild, settings)
        if success then
            message.channel:sendf("Set the prefix to `%s`!", args[1])
        else
            message:reply("Was unable to set the prefix for the guild. If this continues, message the bot owner.")
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