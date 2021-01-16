local Get = require("get")
local get = require "get"

local name = "echo" -- Name of the command.

local permissions = {
    bot_owner = false, -- Whether only the bot owner can use this command.
    manage_server = false, -- Whether you must have `Manage Server` to use this command.
    moderator = true, -- Whether you must be manually given permission to use this command.
}

local run_perms = {  } -- List of permissions that are required to run the command

local signature = "echo <channel> [text]" -- Type signature of the command for help files.

-- Array of information about arguments for help files.
--eg: {false, "arg", "This is an argument."}, {true, "optionalArg", "This argument is optional"}
local args = {
    {true, "channel", "The channel to echo the `text` into. Defaults to the channel the command is ran in."},
    {false, "text", "The text for the bot to echo."},
}

-- Description of each command for help files.
local description = [[
Causes the bot to repeat a message, optionally into a specific channel. Ostensibly for serious testing, but in practice is mostly for goofs.]]

-- The code block that gets executed when the command is ran.
---@param guild Guild
---@param author User
---@param message Message
---@param args string[]
local function command(guild, author, message, args)
    if #args == 0 then
        message:reply("You must specify some text to echo.")
        return
    end
    ---@type string
    local text
    ---@type GuildTextChannel
    local recepient
    do
        local found, channel = Get.textChannel(guild, args[1])
        if found then
            text = table.concat(args, " ", 2)
            recepient = channel
        else
            text = table.concat(args, " ")
            message:reply(channel)
            recepient = message.channel
        end
    end

    recepient:send(text)
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