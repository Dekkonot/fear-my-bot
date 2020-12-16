local pathjoin = require("pathjoin")
local pathJoin = pathjoin.pathJoin

local BASE_DIRECTORY = pathJoin("commands", "command_files")

local commands = {
    ["internal"] = {
        "ping", "reload_command", "client_info", "purge_cache", "exec", "restart", "memory_info"
    },
    ["management"] = {
        "block_permissions", "give_permissions", "reset_permissions", "set_prefix",
    },
    ["misc"] = {
        "help", "alias", "view_alias", "clear_alias"
    }
}

local commandData = {}

for category, commandList in pairs(commands) do
    for _, commandName in ipairs(commandList) do
        local path = pathJoin(BASE_DIRECTORY, category, commandName)
        local command = require(path)
        if commandData[command.name] then
            error("could not load base commands: duplicate command name '" .. command .. "'", 2)
        end
        commandData[command.name] = {command, path}
    end
end

return commandData