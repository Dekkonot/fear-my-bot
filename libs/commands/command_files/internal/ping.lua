local OS = jit.os

local packets = 1

local COMMAND_STRING = string.format("ping discord.com -c %i -t 255 -q", packets)

local name = "ping" -- Name of the command.

local permissions = {
	bot_owner = false, -- Whether only the bot owner can use this command.
	manage_server = false, -- Whether you must have `Manage Server` to use this command.
	moderator = false, -- Whether you must be manually given permission to use this command.
}

local run_perms = {} -- List of permissions that are required to run the command

local signature = "ping" -- Type signature of the command for help files.

-- Array of information about arguments for help files.
--eg: {false, "arg", "This is an argument."}, {true, "optionalArg", "This argument is optional"}
local args = {}

-- Description of each command for help files.
local description = [[
Pings the bot, making it show the delay between the client and Discord's server]]

-- The code block that gets executed when the command is ran.
---@param guild Guild
---@param author User
---@param message Message
---@param args string[]
local function command(guild, author, message, args)
	local pingMessage = message:reply("Ping! :ping_pong:")
	
	local pingHandle, output, ping
	if OS == "Linux" then
		pingHandle = io.popen(COMMAND_STRING)
		output = pingHandle:read("*a")
		local min, avg, max, _ = output:match("(%d+%.%d+)/(%d+%.%d+)/(%d+%.%d+)/(%d+%.%d+) ms")
		pingMessage:setContent(string.format("Pong! :ping_pong: **[%.2f ms]**", avg))
	elseif OS == "Windows" then -- TODO: Figure this out on windows
		pingMessage:setContent("Could not run ping command on Windows.")
	else
		pingMessage:setContent(string.format("Could not run ping command on %s.", OS))
	end
	
	pingHandle:close()
end

return {
	name = name,

	permissions = permissions,
	run_perms = run_perms,

	signature = signature,
	args = args,
	description = description,

	command = command,
}
