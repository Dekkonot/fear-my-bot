local GuildInfo = require("guild_info")

local name = "viewalias" -- Name of the command.

local permissions = {
    bot_owner = false, -- Whether only the bot owner can use this command.
    manage_server = true, -- Whether you must have `Manage Server` to use this command.
    moderator = false, -- Whether you must be manually given permission to use this command.
}

local run_perms = {  } -- List of permissions that are required to run the command

local signature = "viewalias <alias name>" -- Type signature of the command for help files.

-- Array of information about arguments for help files.
--eg: {false, "arg", "This is an argument."}, {true, "optionalArg", "This argument is optional"}
local args = {
    {true, "alias name", "The name of the alias to view the contents of"}
}

-- Description of each command for help files.
local description = [[
Views a previously established alias. For more information on aliases, see `alias`.

If `alias name` is not provided, a list of all aliases is provided instead.]]

-- The code block that gets executed when the command is ran.
---@param guild Guild
---@param author User
---@param message Message
---@param args string[]
local function command(guild, author, message, args)
    local aliases = GuildInfo.getTable(guild, "aliases")
    if #args == 0 then
        local aliasList = {}
        for k in pairs(aliases) do
            aliasList[#aliasList + 1] = string.format("  • `%s`", k)
        end
        table.sort(aliasList)

        message:reply("Alias List:\n" .. table.concat(aliasList, "\n"))
    else
        local alias = aliases[args[1]]
        if not alias then
            message:reply("That alias does not exist.")
            return
        end

        message:reply(string.format("`%s` - `%s`", args[1], alias))
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