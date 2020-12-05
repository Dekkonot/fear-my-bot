local jit = require("jit")

local OS_STRING = jit.os
local BOT_STRING
if args then
    BOT_STRING = table.concat(args, " ", 0)
end

local name = "restart" -- Name of the command.

local permissions = {
    bot_owner = true, -- Whether only the bot owner can use this command.
    manage_server = false, -- Whether you must have `Manage Server` to use this command.
    moderator = false, -- Whether you must be manually given permission to use this command.
}

local run_perms = {  } -- List of permissions that are required to run the command

local signature = "restart" -- Type signature of the command for help files.

-- Array of information about arguments for help files.
--eg: {false, "arg", "This is an argument."}, {true, "optionalArg", "This argument is optional"}
local args = {

}

-- Description of each command for help files.
local description = [[
Restarts the bot by directly calling `os.execute` based on the global `args`.

If `args` is nil, it will just close the bot.

Uses `start` on Windows, `open` on OSX, and `xdg-open` on Linux.]]

-- The code block that gets executed when the command is ran.
---@param guild Guild
---@param author User
---@param message Message
---@param args string[]
local function command(guild, author, message, args)
    guild.client:stop()
    if not BOT_STRING then
        os.exit(0)
    end

    if OS_STRING == "Windows" then
        os.execute("start " .. BOT_STRING)
    elseif OS_STRING == "Linux" then
        os.execute("xdg-open " .. BOT_STRING)
    elseif OS_STRING == "OSX" then
        os.execute("open " .. BOT_STRING)
    end

    os.exit(0)
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