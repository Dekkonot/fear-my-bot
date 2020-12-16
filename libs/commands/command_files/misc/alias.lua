local AliasManager = require("alias_manager")
local Commands = require("commands")

local commandMap = Commands.commandMap

local name = "alias" -- Name of the command.

local permissions = {
    bot_owner = false, -- Whether only the bot owner can use this command.
    manage_server = true, -- Whether you must have `Manage Server` to use this command.
    moderator = false, -- Whether you must be manually given permission to use this command.
}

local run_perms = {  } -- List of permissions that are required to run the command

local signature = "alias [alias name] [command]" -- Type signature of the command for help files.

-- Array of information about arguments for help files.
--eg: {false, "arg", "This is an argument."}, {true, "optionalArg", "This argument is optional"}
local args = {
    {false, "alias name", "The name of the alias being established"},
    {false, "command", "A command to alias. See the description for an explanation of the syntax."}
}

-- Description of each command for help files.
local description = [[
Establishes an alias for the given command along with the given arguments. Aliases are shortcuts to run a command with a given set of arguments.

As an example, `alias pong ping` would cause `pong` to run `ping`.

When aliases are invoked, any instance of `%n` (where n is a number) is substituted for the nth argument passed to the invokation.

Likewise:
  • The entire argument string can be specified with `%0`.
  • A range of arguments from argument `x` to argument `y can be specified with `%x..%y`.
  • An open ended range from argument `x` onwards can be specified with `%x..`. Use `%1..%x` to specify the other way.
  • The invoking user's ID can be specified via `%me`. This ID is usable in all commands.
  • The `%` character can be specified with `%%`.
  
As an example, `alias help pleh %1` would cause `pleh alias` to run `help alias`.

To **view** an alias's content or view a list of them, use `viewalias`. To **erase** one, use `clearalias`.]]

-- The code block that gets executed when the command is ran.
---@param guild Guild
---@param author User
---@param message Message
---@param args string[]
local function command(guild, author, message, args)
    if #args == 0 then
        message:reply("You must specify a name for the alias.")
        return
    elseif #args == 1 then
        message:reply(
            "You must specify a command to set an alias for.\n\n" ..
            "If you're trying to view an alias, use `viewalias`. If you're trying to delete one, use `clearalias`."
        )
        return
    elseif not commandMap[args[2]] then
        message:reply("You must alias a command. If you're trying to alias an alias, try re-making it.")
        return
    end

    local success, err = AliasManager.addAlias(guild, args[1]:lower(), table.concat(args, " ", 2))

    if success then
        message:reply(string.format("Successfully created alias `%s`.", args[1]))
    else
        message:reply("Cannot set alias because: " .. err .. ".")
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