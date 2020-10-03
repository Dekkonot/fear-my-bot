local ORIGINAL_SYMBOL = {}

local MESSAGE_WRAPPER = {__index = function(self, index)
    return self[ORIGINAL_SYMBOL][index]
end}

local AT_MT = {__index = function(_, id)
    return "@" .. id
end}
local POUND_MT = {__index = function(_, id)
    return "#" .. id
end}
local ZWSP = "\xe2\x80\x8b"
local EVERYONE_REPLACE = "@"..ZWSP.."everyone"
local HERE_REPLACE = "@"..ZWSP.."here"

local function clean(client, guild, content)
    local users = setmetatable({}, AT_MT)
    local roles = setmetatable({}, AT_MT)
    local channels = setmetatable({}, POUND_MT)
    if guild then
        for id in string.gmatch(content, "<@!?(%d+)>") do
            local user = client.users:get(id)
            if user then
                local member = guild.members:get(id)
                users[id] = "@" .. (member and member.name or user.username)
            end
        end
        for id in string.gmatch(content, "<@&(%d+)>") do
            local role = guild.roles:get(id)
            if role then
                roles[id] = "@" .. role.name
            end
        end
        for id in string.gmatch(content, "<#(%d+)>") do
            local channel = guild.textChannels:get(id) or guild.voiceChannels:get(id) or guild.categories:get(id)
            if channel then
                channels[id] = "#" .. channel.name
            end
        end
    else
        for id in string.gmatch(content, "<#(%d+)>") do
            local channel = guild.privateChannels:get(id) or guild.groupChannels:get(id)
            if channel then
                channels[id] = "#" .. channel.name
            end
        end
    end

    return content
        :gsub("<@!?(%d+)>", users)
        :gsub("<@&(%d+)>", roles)
        :gsub("<#(%d+)>", channels)
        :gsub("<a?(:[%w_]+:)%d+>", "%1") -- Emotes
        :gsub("@everyone", EVERYONE_REPLACE)
        :gsub("@here", HERE_REPLACE)
end

---Wraps a message so that it can be treated as having a new member and optionally a new contents.
---@param message Message
---@param newMember Member
---@param newContent string
---@return Message
local function wrap(message, newMember, newContent)
    local client, guild, content = message.client, message.guild, message.content
    local newMessage = {
        member = newMember,
        author = newMember.user,
        content = newContent or content,
        cleanContent = newContent and clean(client, guild, newContent) or message.cleanContent,
        [ORIGINAL_SYMBOL] = message,
    }
    return setmetatable(newMessage, MESSAGE_WRAPPER)
end

return wrap