local Commands = require("commands")
local GuildInfo = require("guild_info")

local format = string.format

local OVERRIDE_MT = {
    __index = {
        global = {},
        commands = {}
    }
}

---Gets a table from `baseContainer` in a path, creating a table wherever a piece of the chain is missing.
---e.g.: `getOverrideTable({}, "global", "roles")` would result in a table like `{ globals = { roles = {} } }`
---and would return `tbl.globals.roles`.
---@param baseContainer table
local function getOverrideTable(baseContainer, ...)
    local tbl = baseContainer
    for i = 1, select("#", ...) do
        local index = select(i, ...)
        local value = tbl[index]
        if not value then
            value = {}
            tbl[index] = value
        end
        tbl = value
    end
    return tbl
end

---@param roles ArrayIterable
---@param overrideTable table
---@return boolean|nil
local function checkRoles(roles, overrideTable)
    local roleTable = overrideTable.roles
    if not roleTable then return nil end

    local status = nil

    for id in pairs(roles) do
        local override = roleTable[id]
        if override == false then
            -- If `status` is ever set to `false`, we should break.
            return false
        else
            status = override
        end
    end
    return status
end

---@param user User
---@param overrideTable table
---@return boolean|nil
local function checkUser(user, overrideTable)
    local userTable = overrideTable.users
    if not userTable then return nil end

    return userTable[user.id]
end

---Returns whether a given user can use a command in a particular guild.
---@param guild Guild
---@param user User
---@param commandData Command
---@return boolean
local function canUseCommand(guild, user, commandData)
    local cmdPerms = commandData.user_permissions
    local cmdName = commandData.name

    if cmdPerms.bot_owner then
        if guild.client.owner == user then
            return true
        else
            return false
        end
    end

    local guildMember = guild:getMember(user)

    local canManageServer = guildMember:hasPermission("manageGuild")
    local isMod = false

    if cmdPerms.manage_server then
        if canManageServer then
            return true
        else
            return false
        end
    end

    --Overarching priority: command, global
    --Per level priority: user block, user allow, role block, role allow
    local manualOverrides = GuildInfo.getTable(guild, "permission_overrides")
    setmetatable(manualOverrides, OVERRIDE_MT)

    do
        local finalOverrideStatus = nil
        local globalOverrides = manualOverrides.global

        local commandOverrides = manualOverrides.commands[cmdName]
        if commandOverrides then
            finalOverrideStatus = checkUser(user, commandOverrides)

            if finalOverrideStatus == nil then
                finalOverrideStatus = checkRoles(guildMember.roles, commandOverrides)
            end
        end
        if finalOverrideStatus == nil then
            finalOverrideStatus = checkUser(user, globalOverrides)
            if finalOverrideStatus == nil then
                finalOverrideStatus = checkRoles(guildMember.roles, globalOverrides)
            end
        end
        if finalOverrideStatus == true then
            isMod = true
        elseif finalOverrideStatus == false then
            return false
        end
    end

    if cmdPerms.moderator then
        if isMod or canManageServer then
            return true
        else
            return false
        end
    end

    return true
end

---Gets a list of commands that are usable by a particular member of a guild.
---@param guild Guild
---@param user User
---@return string[]
local function usableCommandList(guild, user)
    local prefix = GuildInfo.getSettings(guild).prefix

    local guildMember = guild:getMember(user)
    local memberRoles = guildMember.roles

    local isBotOwner = guild.client.owner == user
    local canManageServer = guildMember:hasPermission("manageGuild")
    local isMod = false

    local manualOverrides = GuildInfo.getTable(guild, "permission_overrides")
    setmetatable(manualOverrides, OVERRIDE_MT)

    local globalOverrides = manualOverrides.global
    local commandOverrides = manualOverrides.commands

    if checkUser(user, globalOverrides) or checkRoles(memberRoles, globalOverrides) then
        isMod = true
    end

    local usableCommands = {}
    local i = 1
    for name, commandData in pairs(Commands.commandMap) do
        local add = true
        local cmdPerms = commandData.user_permissions

        if cmdPerms.bot_owner then
            if not isBotOwner then
                add = false
            end
        end

        if cmdPerms.manage_server then
            if not canManageServer then
                add = false
            end
        end

        if cmdPerms.moderator then
            if not (isMod or canManageServer) then
                local cmdOverrides = commandOverrides[name]
                if cmdOverrides then
                    if not checkUser(user, cmdOverrides) or checkRoles(memberRoles, cmdOverrides) then
                        add = false
                    end
                else
                    add = false
                end
            end
        end

        if add then
            usableCommands[i] = format("%s%s", prefix, name)
            i = i + 1
        end
    end

    return table.concat(usableCommands, ", ")
end

---Sets the override for a member of a particular guild to `true', optionally localized to a specific command.
---@param guild Guild
---@param user User
---@param commandData Command
---@return boolean
local function setPositiveMemberOverride(guild, user, commandData)
    local manualOverrides = GuildInfo.getTable(guild, "permission_overrides")

    local overrideTable
    if commandData then
        overrideTable = getOverrideTable(manualOverrides, "commands", commandData.name, "users")
    else
        overrideTable = getOverrideTable(manualOverrides, "global", "users")
    end

    overrideTable[user.id] = true

    return GuildInfo.setTable(guild, "permission_overrides", manualOverrides)
end

---Sets the override for a role of a particular guild to `true', optionally localized to a specific command.
---@param guild Guild
---@param role Role
---@param commandData Command
---@return boolean
local function setPositiveRoleOverride(guild, role, commandData)
    local manualOverrides = GuildInfo.getTable(guild, "permission_overrides")

    local overrideTable
    if commandData then
        overrideTable = getOverrideTable(manualOverrides, "commands", commandData.name, "roles")
    else
        overrideTable = getOverrideTable(manualOverrides, "global", "roles")
    end

    overrideTable[role.id] = true

    return GuildInfo.setTable(guild, "permission_overrides", manualOverrides)
end

---Sets the override for a member of a particular guild to `nil', optionally localized to a specific command.
---@param guild Guild
---@param user User
---@param commandData Command
---@return boolean
local function setNeutralMemberOverride(guild, user, commandData)
    local manualOverrides = GuildInfo.getTable(guild, "permission_overrides")

    local overrideTable
    if commandData then
        overrideTable = getOverrideTable(manualOverrides, "commands", commandData.name, "users")
    else
        overrideTable = getOverrideTable(manualOverrides, "global", "users")
    end
    overrideTable[user.id] = nil

    return GuildInfo.setTable(guild, "permission_overrides", manualOverrides)
end

---Sets the override for a role of a particular guild to `nil', optionally localized to a specific command.
---@param guild Guild
---@param role Role
---@param commandData Command
---@return boolean
local function setNeutralRoleOverride(guild, role, commandData)
    local manualOverrides = GuildInfo.getTable(guild, "permission_overrides")

    local overrideTable
    if commandData then
        overrideTable = getOverrideTable(manualOverrides, "commands", commandData.name, "roles")
    else
        overrideTable = getOverrideTable(manualOverrides, "global", "roles")
    end

    overrideTable[role.id] = nil

    return GuildInfo.setTable(guild, "permission_overrides", manualOverrides)
end

---Sets the override for a member of a particular guild to `false', optionally localized to a specific command.
---@param guild Guild
---@param user User
---@param commandData Command
---@return boolean
local function setNegativeMemberOverride(guild, user, commandData)
    local manualOverrides = GuildInfo.getTable(guild, "permission_overrides")

    local overrideTable
    if commandData then
        overrideTable = getOverrideTable(manualOverrides, "commands", commandData.name, "users")
    else
        overrideTable = getOverrideTable(manualOverrides, "global", "users")
    end

    overrideTable[user.id] = false

    return GuildInfo.setTable(guild, "permission_overrides", manualOverrides)
end

---Sets the override for a role of a particular guild to `false', optionally localized to a specific command.
---@param guild Guild
---@param role Role
---@param commandData Command
---@return boolean
local function setNegativeRoleOverride(guild, role, commandData)
    local manualOverrides = GuildInfo.getTable(guild, "permission_overrides")

    local overrideTable
    if commandData then
        overrideTable = getOverrideTable(manualOverrides, "commands", commandData.name, "roles")
    else
        overrideTable = getOverrideTable(manualOverrides, "global", "roles")
    end

    overrideTable[role.id] = false

    return GuildInfo.setTable(guild, "permission_overrides", manualOverrides)
end

return {
    canUseCommand = canUseCommand,
    usableCommandList = usableCommandList,

    setPositiveMemberOverride = setPositiveMemberOverride,
    setPositiveRoleOverride = setPositiveRoleOverride,

    setNeutralMemberOverride = setNeutralMemberOverride,
    setNeutralRoleOverride = setNeutralRoleOverride,

    setNegativeMemberOverride = setNegativeMemberOverride,
    setNegativeRoleOverride = setNegativeRoleOverride,
}