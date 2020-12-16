local Commands = require("commands")
local GuildInfo = require("guild_info")

local DIVISION_BYTE = string.byte("%")
local DOT_BYTE = string.byte(".")
local M_BYTE, E_BYTE = string.byte("me", 1, 2)
local NUMBER_BYTES = {}
for i = 0, 9 do
    NUMBER_BYTES[string.byte(tostring(i))] = true
end

---@param str string
---@param i number
--- Reads a number from `str`, starting at position `i`.
--- If successful, returns `true`, `number`, and `new i` such that `new i` will be the end of the number in the string.
--- If unsuccessful, returns `false` and an error message indicating why.
local function readNumber(str, i)
    local _, numberEnd = string.find(str, "%d+", i)
    if not numberEnd then
        return false, "no number at position" .. tostring(i)
    end
    local numberString = string.sub(str, i, numberEnd)
    local number = tonumber(numberString)
    if not number then
        return false, "malformed number at position " .. tostring(i)
    end

    return true, number, i + #numberString
end

---@param guild Guild
---@param binding string
---@param alias string
--- Adds `alias` to `guild` with the name `binding`.
--- As an example, `addAlias(guild, "foo", "bar baz")` would add `foo` as an alias for `bar baz`.
local function addAlias(guild, binding, alias)
    if Commands.commandMap[binding] then
        return false, "cannot give an alias the same name as a real command"
    end
    local aliasTable = GuildInfo.getTable(guild, "aliases")
    if aliasTable[binding] then
        return false, "cannot give two aliases the same name"
    end

    aliasTable[binding] = alias

    local set = GuildInfo.setTable(guild, "aliases", aliasTable)

    if not set then
        return false, "unable to add alias"
    end

    return true
end

---@param guild Guild
---@param binding string
--- Removes the association of `binding` from `guild`.
--- As an example, `removeAlias(guild, "foo")` would remove whatever alias was associated with `foo`.
local function removeAlias(guild, binding)
    local aliasTable = GuildInfo.getTable(guild, "aliases")

    aliasTable[binding] = nil

    local set = GuildInfo.setTable(guild, "aliases", aliasTable)

    if not set then
        return false, "unable to remove alias"
    end

    return true
end

local function escapeAlias(alias, args, speaker)
    local id = speaker.id

    local parsed = {}
    local c = 1

    --%0 = entire arg string
    --%me = speaker.id
    --%n = arg n
    --%x.. = args [x, inf]
    --%x..%y = args [x, y]
    --%% = %

    local i = 1
    local aliasLen = #alias
    while i <= aliasLen do
        local nextEscape = string.find(alias, "%", i, true)
        if not nextEscape then
            -- we can safely add the rest of the string
            parsed[c] = string.sub(alias, i, -1)
            i = math.huge
        else
            if nextEscape - i > 0 then
                parsed[c] = string.sub(alias, i, nextEscape - 1)
                c = c + 1
            end
            local escapeChar = string.byte(alias, nextEscape + 1)
            if escapeChar == DIVISION_BYTE then
                parsed[c] = "%"
                c = c + 1
                i = nextEscape + 2
            elseif escapeChar == M_BYTE and string.byte(alias, nextEscape + 2) == E_BYTE then
                parsed[c] = id
                c = c + 1
                i = nextEscape + 3
            elseif NUMBER_BYTES[escapeChar] then
                local number
                do
                    local readSuccess
                    readSuccess, number, i = readNumber(alias, nextEscape + 1)
                    if not readSuccess then
                        return false, number
                    end
                end

                local next1, next2 = string.byte(alias, i, i + 1) -- bad variable names are bad

                if next1 == DOT_BYTE and next2 == DOT_BYTE then
                    local next3 = string.byte(alias, i + 2)
                    if next3 == DIVISION_BYTE then
                        local firstNumber = number
                        do
                            local readSuccess
                            readSuccess, number, i = readNumber(alias, i + 3)
                            if not readSuccess then
                                return false, number
                            end
                        end
                        parsed[c] = table.concat(args, " ", firstNumber + 1, number + 1)
                    else
                        i = i + 2
                        parsed[c] = table.concat(args, " ", number + 1)
                    end
                else
                    -- Because we don't format `args` before passing it to
                    -- this, we have to offset arguments by 1
                    if number == 0 then
                        parsed[c] = table.concat(args, " ", 2)
                    else
                        parsed[c] = args[number + 1] or ""
                    end
                end
                c = c + 1
                -- We don't have to offset `i` here because it's easier to do
                -- it as-needed above
            else
                return false, "unfinished escape at position " .. tostring(i)
            end
        end
    end
    return true, table.concat(parsed, "", 1, c)
end

return {
    addAlias = addAlias,
    removeAlias = removeAlias,

    escapeAlias = escapeAlias,
}