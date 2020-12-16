local AliasManager = require("alias_manager")

local name = "clearalias" -- Name of the command.

local permissions = {
    bot_owner = false, -- Whether only the bot owner can use this command.
    manage_server = true, -- Whether you must have `Manage Server` to use this command.
    moderator = false, -- Whether you must be manually given permission to use this command.
}

local run_perms = {  } -- List of permissions that are required to run the command

local signature = "clearalias [alias name]" -- Type signature of the command for help files.

-- Array of information about arguments for help files.
--eg: {false, "arg", "This is an argument."}, {true, "optionalArg", "This argument is optional"}
local args = {
    {false, "alias name", "The name of the aliases to delete"}
}

-- Description of each command for help files.
local description = [[
Deletes a given alias, freeing it up for a new alias.

This cannot be undone, so be careful!]]

-- The code block that gets executed when the command is ran.
---@param guild Guild
---@param author User
---@param message Message
---@param args string[]
local function command(guild, author, message, args)
    if #args == 0 then
        message:reply("You must specify an alias to delete.")
        return
    end

    local removed = AliasManager.removeAlias(guild, args[1])

    if removed then
        message:reply("Removed the alias.")
    else
        message:reply("Could not remove the alias. If this persists, contact the bot owner.")
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