local Commands = require("commands")
local Permissions = require("permissions")
local Get = require("get")

local name = "giveperms" -- Name of the command.

local permissions = {
    bot_owner = false, -- Whether only the bot owner can use this command.
    manage_server = true, -- Whether you must have `Manage Server` to use this command.
    moderator = false, -- Whether you must be manually given permission to use this command.
}

local run_perms = {  } -- List of permissions that are required to run the command

local signature = "giveperms [thing] <command>" -- Type signature of the command for help files.

-- Array of information about arguments for help files.
--eg: {false, "arg", "This is an argument."}, {true, "optionalArg", "This argument is optional"}
local args = {
    {true, "thing", "The object to give permissions to"},
    {false, "command", "What command, if any, to give the `thing` permission to use"},
}

-- Description of each command for help files.
local description = [[
Gives a specific user or role the ability to use moderator commands, optionally for a specific command.

If `thing` is a user, that user is allowed to use moderator commands. If `thing` is a role, anyone with that role will automatically be allowed to use moderator commands.

If `command` is given, the `given` thing will only be allowed to use that command.

Giving someone permissions with this command won't allow them to uses commands that require `Manage Server`, like `giveperms`.

Additionally, if someone is blocked from using command(s) via `blockperms`, giving them permissions with `giveperms` will not override it.]]

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
        local saved = Permissions.setPositiveMemberOverride(guild, user, commandData)

        if saved then
            if commandData then
                message:reply(string.format("Successfully gave user `%s` permission to use command `%s`!", user.tag, cmdName))
            else
                message:reply(string.format("Successfully gave user `%s` permissions to use moderator commands!", user.tag))
            end
        else
            message:reply(string.format("Failed to update the permissions for user `%s`. Please try again later.", user.tag))
        end
        return
    else
        local saved = Permissions.setPositiveRoleOverride(guild, role, commandData)

        if saved then
            if commandData then
                message:reply(string.format("Successfully gave role `%s` permission to use command `%s`!", role.name, cmdName))
            else
                message:reply(string.format("Successfully gave role `%s` permissions to use moderator commands!", role.name))
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