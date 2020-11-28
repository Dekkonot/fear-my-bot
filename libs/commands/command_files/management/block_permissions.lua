local Commands = require("commands")
local Permissions = require("permissions")
local Get = require("get")

local name = "blockperms" -- Name of the command.

local permissions = {
    bot_owner = false, -- Whether only the bot owner can use this command.
    manage_server = true, -- Whether you must have `Manage Server` to use this command.
    moderator = false, -- Whether you must be manually given permission to use this command.
}

local run_perms = {  } -- List of permissions that are required to run the command

local signature = "blockperms [thing] <command>" -- Type signature of the command for help files.

-- Array of information about arguments for help files.
--eg: {false, "arg", "This is an argument."}, {true, "optionalArg", "This argument is optional"}
local args = {
    {true, "thing", "The object to block permissions for"},
    {false, "command", "What command, if any, to block the `thing` from using"},
}

-- Description of each command for help files.
local description = [[
Blocks a specific user or role from using moderator commands or optionally from using a specific command.

If `thing` is a user, that user is blocked from using moderator commands. If `thing` is a role, anyone with that role will automatically be blocked from using moderator commands.

If `command` is given, the block will only apply to that specific command. This will block non-moderator commands, so it can be used to effectively disable certain commands.

Blocking someone won't prevent them from using commands that require `Manage Server`, like `blockperms`.

Additionally, if someone has any blocks in place (either on their user or a role they have), it will override any permissions given with `giveperm`.]]

-- The code block that gets executed when the command is ran.
---@param guild Guild
---@param author User
---@param message Message
---@param args string[]
local function command(guild, author, message, args)
    if #args == 0 then
        message:reply("No user/role provided. See this command's help text for more information.")
        return
    end
    local mention = args[1]
    local gotMember, member = Get.member(guild, mention, false)
    local gotRole, role = Get.role(guild, mention, false)

    if gotMember and gotRole then
        message:reply("Found both a user and a role by that name. Try using a mention or the ID of the thing you want to reference.")
        return
    elseif not (gotMember or gotRole) then
        message:reply("Couldn't find a user or role by that name/id. Try using a mention or the ID of the thing you want to reference.")
        return
    end
    local commandData
    local cmdName = args[2]
    if cmdName then
        cmdName = string.lower(cmdName)
        commandData = Commands.getCommandData(cmdName)
        if not commandData or not Permissions.canUseCommand(guild, author, commandData) then
            message:reply(string.format("Command `%s` doesn't exist or is inaccessible to you.", cmdName))
            return
        end
    end

    if gotMember then
        local user = member.user
        local saved = Permissions.setNegativeMemberOverride(guild, user, commandData)

        if saved then
            if commandData then
                message:reply(string.format("Successfully blocked user `%s` from being able to use command `%s`!", user.tag, cmdName))
            else
                message:reply(string.format("Successfully blocked user `%s` from being able to use moderator commands!", user.tag))
            end
        else
            message:reply(string.format("Failed to update the permissions for user `%s`. Please try again later.", user.tag))
        end
        return
    else
        local saved = Permissions.setNegativeRoleOverride(guild, role, commandData)

        if saved then
            if commandData then
                message:reply(string.format("Successfully blocked role `%s` from being able to use command `%s`!", role.name, cmdName))
            else
                message:reply(string.format("Successfully blocked role `%s` from being able to use use moderator commands!", role.name))
            end
        else
            message:reply(string.format("Failed to update the permissions for role `%s`. Please try again later.", role.name))
        end
        return
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