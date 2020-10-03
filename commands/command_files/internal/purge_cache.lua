local GuildInfo = require("guild_info")
local Get = require("get")
local purgeCache = GuildInfo.purgeCache

local name = "purgecache" -- Name of the command.

local permissions = {
    bot_owner = true, -- Whether only the bot owner can use this command.
    manage_server = false, -- Whether you must have `Manage Server` to use this command.
    moderator = false, -- Whether you must be manually given permission to use this command.
}

local run_perms = {  } -- List of permissions that are required to run the command

local signature = "purgecache <guildId> <name>" -- Type signature of the command for help files.

-- Array of information about arguments for help files.
--eg: {false, "arg", "This is an argument."}, {true, "optionalArg", "This argument is optional"}
local args = {
    {false, "guildId", "The guild to purge the cache for"},
    {false, "name", "The specific table to purge from the cache"},
}

-- Description of each command for help files.
local description = [[
Purges the GuildInfo cache for a specific guild.

If no arguments are provided, the guild the command is run in is purged. If `guildId` is provided, the specified guild will be purged. If `name` is provided, a specific guild table will be purged from the cache rather than the whole cache.]]

-- The code block that gets executed when the command is ran.
---@param guild Guild
---@param author User
---@param message Message
---@param args string[]
local function command(guild, author, message, args)
    local channel = message.channel
    local argCount = #args
    if argCount == 0 then
        purgeCache(guild.id)
        channel:sendf("Purged the cache for guild `%s` (ID: %s)", guild.name, guild.id)
    else
        local foundGuild, targetGuild
        if args[1]:lower() == "$here" then
            foundGuild, targetGuild = true, guild
        else
            foundGuild, targetGuild = Get.guild(guild.client, args[1])
        end
        if foundGuild then
            if argCount > 1 then
                purgeCache(args[1], args[2]:lower())
                channel:sendf("Purged table `%s` from the cache for guild `%s` (ID: %s)", args[2]:lower(), targetGuild.name, targetGuild.id)
            else
                purgeCache(args[1])
                channel:sendf("Purged the cache for guild `%s` (ID: %s)", targetGuild.name, targetGuild.id)
            end
        else
            channel:send(targetGuild)
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