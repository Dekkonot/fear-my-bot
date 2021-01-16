---Resolves a mention string into a member from a particular guild.
---@param guild Guild
---@param mention string
---@param allowBot boolean
local function getMember(guild, mention, allowBot)
    local guildMembers = guild.members
    do
        local member = guildMembers:get(mention)
        if not member then
            if string.find(mention, "^@") then
                if string.find(mention, "^@!") then
                    member = guildMembers:get(string.sub(mention, 3))
                else
                    member = guildMembers:get(string.sub(mention, 2))
                end
            elseif string.find(mention, "^<@!?%d+>") then
                member = guildMembers:get(string.match(mention, "^<@!?(%d+)>"))
            end
        end
        if member then
            if member.user.bot then
                if allowBot then
                    return true, member
                end
            else
                return true, member
            end
        end
    end

    local memberCount = 0
    local foundMember

    local mentionLen = #mention
    local mentionLower = mention:lower()

    ---@param member Member
    for _, member in pairs(guildMembers) do
        local continue = true
        if member.user.bot then
            if not allowBot then
                continue = false
            end
        end
        if continue then
            local tag = member.user.tag
            local name = member.name:lower()
            local username = member.user.username:lower()

            if mention == tag then
                return true, member -- As it turns out, there will never be duplicate tags, so it's okay
            end
            if string.sub(name, 1, mentionLen) == mentionLower then
                foundMember = member
                memberCount = memberCount + 1
            elseif string.sub(username, 1, mentionLen) == mentionLower then
                foundMember = member
                memberCount = memberCount + 1
            end
        end
    end

    if memberCount == 1 then
        return true, foundMember
    elseif memberCount == 0 then
        return false, "No members were found by that name/ID. Try using their exact ID or tag."
    else
        return false, "Multiple members were found by that name/ID. Try using their exact ID or tag."
    end
end

---Resolves a mention string into a guild from a client.
---@param client Client
---@param mention string
local function getGuild(client, mention)
    local guildCount = 0
    local foundGuild

    local mentionLen = #mention
    local mentionLower = mention:lower()

    ---@param guild Guild
    ---@param id SnowflakeId
    for id, guild in pairs(client.guilds) do
        if id == mention then
            return true, guild
        end
        if string.sub(guild.name, 1, mentionLen):lower() == mentionLower then
            foundGuild = guild
            guildCount = guildCount + 1
        end
    end

    if guildCount == 1 then
        return true, foundGuild
    elseif guildCount == 0 then
        return false, "No guilds were found by that name/ID. Are you running on the right shard?"
    else
        return false, "Multiple guilds were found by that name/ID. Try using a guild's exact ID."
    end
end

---Resolves a mention string into a role from a particular guild.
---@param guild Guild
---@param mention string
---@param allowManaged boolean
local function getRole(guild, mention, allowManaged)
    local guildRoles = guild.roles
    do
        local role = guildRoles:get(mention)
        if not role then
            if string.find(mention, "^@") then
                if string.find(mention, "^@&") then
                    role = guildRoles:get(string.sub(mention, 3))
                else
                    role = guildRoles:get(string.sub(mention, 2))
                end
            end
        elseif string.find(mention, "^<@&?%d+>") then
            role = guildRoles:get(string.match(mention, "^<@&?%d+>"))
        end
        if role then
            if role.managed then
                if allowManaged then
                    return true, role
                end
            else
                return true, role
            end
        end
    end

    local roleCount = 0
    local foundRole

    local mentionLen = #mention
    local mentionLower = mention:lower()

    ---@param role Role
    for _, role in pairs(guildRoles) do
        local continue = true
        if role.managed then
            if not allowManaged then
                continue = false
            end
        end
        if continue then
            if string.sub(role.name, 1, mentionLen):lower() == mentionLower then
                foundRole = role
                roleCount = roleCount + 1
            end
        end
    end

    if roleCount == 1 then
        return true, foundRole
    elseif roleCount == 0 then
        return false, "No roles were found by that name/ID. Try using the role's exact ID."
    else
        return false, "Multiple roles were found by that name/ID. Try using the role's exact ID."
    end
end

---@param guild Guild
---@param mention string
local function getTextChannel(guild, mention)
    local guildChannels = guild.textChannels

    do
        ---@type GuildTextChannel
        local channel = guildChannels:get(mention)
        if not channel then
            if string.find(mention, "^#") then
                channel = guildChannels:get(string.sub(mention, 2))
            elseif string.find(mention, "^<#%d+>$") then
                channel = guildChannels:get(string.match(mention, "<#(%d+)>"))
            end
        end

        if channel then
            return true, channel
        end
    end

    local count = 0
    ---@type GuildTextChannel
    local found

    local mentionLen = #mention
    local mentionLower = string.lower(mention)

    for _, channel in pairs(guildChannels) do
        if string.sub(channel.name, 1, mentionLen) == mentionLower then
            found = channel
            count = count + 1
        end
    end

    if count == 1 then
        return true, found
    elseif count == 0 then
        return false, "No channels were found by that name/ID. Try using the channel's exact ID."
    else
        return false, "Multiple channels were found by that name/ID. Try using the channel's exact ID."
    end
end

return {
    member = getMember,
    guild = getGuild,
    role = getRole,
    textChannel = getTextChannel,
}