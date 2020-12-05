local timer = require("timer")

local ENTRY_DELAY = 1 -- in ms; 1000ms = 1s

local MAX_ENTRIES = 1000 * 60 -- One entry is filled every `ENTRY_DELAY` and cycled

local msLeft = ENTRY_DELAY
local memoryOverTime = {}
local counter = 0

local function addEntry(memory)
    counter = (counter + 1) % MAX_ENTRIES
    memoryOverTime[counter] = memory
end

local function calcAvg()
    local avg = 0
    for _, v in ipairs(memoryOverTime) do
        avg = avg + v
    end
    return avg, avg / MAX_ENTRIES
end

timer.setInterval(ENTRY_DELAY, function()
    msLeft = msLeft - 1
    if msLeft == 0 then
        msLeft = ENTRY_DELAY
        addEntry(collectgarbage("count"))
    end
end)

local name = "memoryinfo" -- Name of the command.

local permissions = {
    bot_owner = true, -- Whether only the bot owner can use this command.
    manage_server = false, -- Whether you must have `Manage Server` to use this command.
    moderator = false, -- Whether you must be manually given permission to use this command.
}

local run_perms = {  } -- List of permissions that are required to run the command

local signature = "memoryinfo" -- Type signature of the command for help files.

-- Array of information about arguments for help files.
--eg: {false, "arg", "This is an argument."}, {true, "optionalArg", "This argument is optional"}
local args = {

}

-- Description of each command for help files.
local description = [[
Returns the amount of memory being used by the bot and the average amount used during the bot's uptime.]]

-- The code block that gets executed when the command is ran.
---@param guild Guild
---@param author User
---@param message Message
---@param args string[]
local function command(guild, author, message, args)
    local _, avg = calcAvg()

    message.channel:sendf(
        "Currently memory usage: `%uKB`. Average memory usage: `%uKB`.\
        \nSample count: `%u`, one collected every `%ums`",
        collectgarbage("count"),
        math.ceil(avg),
        MAX_ENTRIES, ENTRY_DELAY
    )
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