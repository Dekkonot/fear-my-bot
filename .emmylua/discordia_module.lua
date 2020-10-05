---@class Discordia

local Discordia = {
    ---Constructs a new Client object.
    ---When initializing a client, a table of `options` may be passed to the constructor.
    ---
    ---See [this page](https://github.com/SinisterRectus/Discordia/wiki/Client-options) for more info.
    ---@param options table
    ---@return Client
    Client = function(options) end,

    ---Constructs a new Clock object.
    ---Clocks are used to periodically execute code according to the ticking of the system clock instead of arbitrary interal.
    ---@return Clock
    Clock = function() end,

    ---Contructs a new Color object.
    ---Colors are wrappers around 24-bit colors packed as decimal values.
    ---@param value number
    ---@return Color
    Color = function(value) end,

    ---Contructs a new Date object.
    ---Dates represent a single moment in time and provide utilities for converting to and from different date and time formats.
    ---Although microsecond precision is available, most formats are implemented with only second precision.
    ---@param seconds number
    ---@param microseconds number
    ---@return Date
    Date = function(seconds, microseconds) end,

    ---Contructs a new Deque object.
    ---Deques are double ended queues.
    ---@return Deque
    Deque = function() end,

    ---Contructs a new Emitter object.
    ---Emitters are asynchronous event emitter where callbacks can be subscribed to specific named events.
    ---
    ---When events are emitted, the callbacks are called in the order that they were originally registered.
    ---@return Emitter
    Emitter = function() end,

    ---Contructs a new Logger object.
    ---Loggers are used to log formatted messages to stdout or to a file.
    ---The `datetime` argument should be a format string that is accepted by `os.date`.
    ---The file argument should be a relative or absolute file path, or `nil` if no log file is desired.
    ---See the `logLevel` enum for acceptable values for `level`.
    ---@param level enums.logLevel
    ---@param dateTime string
    ---@param file string
    Logger = function(level, dateTime, file) end,

    ---Contructs a new Mutex object.
    ---Mutexs are a mutual exclusion class used to control Lua coroutine execution order.
    ---
    ---See [this StackOverflow answer](https://stackoverflow.com/a/34558) for an explanation of mutexs.
    ---@return Mutex
    Mutex = function() end,

    ---Contructs a new Permissions object.
    ---Permissions are wrappers around a bitfield that is used to represent Discord permissions.
    ---@return Permissions
    Permissions = function() end,

    ---Contructs a new Stopwatch object.
    ---Stopwatches are used to measure an elapsed period of time. Due to limitations with Lua, only up to microsecond accuracy is reliably provided.
    ---If `stopped` is truthy, it the Stopwatch will initialize as stopped. Otherwise, it will initialize as running.
    ---@param stopped boolean
    ---@return Stopwatch
    Stopwatch = function(stopped) end,

    Time = {
        -- [[Time Static Functions]] --

        ---Constructs a new Time object from a value interpreted as days, where a day is equal to 24 hours.
        ---@param t number
        ---@return Time
        fromDays = function(t) end,

        ---Constructs a new Time object from a value interpreted as hours, where an hour is equal to 60 minutes.
        ---@param t number
        ---@return Time
        fromHours = function(t) end,

        ---Constructs a new Time object from a value interpreted as milliseconds.
        ---@param t number
        ---@return Time
        fromMilliseconds = function(t) end,

        ---Constructs a new Time object from a value interpreted as minutes, where a minute is equal to 60 seconds.
        ---@param t number
        ---@return Time
        fromMinutes = function(t) end,

        ---Constructs a new Time object from a value interpreted as seconds, where a second is equal to 1000 milliseconds.
        ---@param t number
        ---@return Time
        fromSeconds = function(t) end,

        ---Constructs a new Time object from a table of time values where the keys are defined as one or more of the contructors
        ---(e.g.: `weeks`, `days`, `milliseconds`).
        ---@param tbl table
        ---@return Time
        fromTable = function(tbl) end,

        ---Constructs a new Time object from a value interpreted as weeks, where a week is equal to 7 days.
        ---@param t number
        ---@return Time
        fromWeeks = function(t) end,
    },

    enums = {
        defaultAvatar = {
            blurple = 0,
            gray = 1,
            green = 2,
            orange = 3,
            red = 4,
        },

        notificationSetting = {
            allMessages = 0,
            onlyMentions = 1,
        },

        channelType = {
            text = 0,
            private = 1,
            voice = 2,
            group = 3,
            category = 4,
            news = 5,
        },

        webhookType = {
            incoming = 1,
            channelFollower = 2,
        },

        messageType = {
            default = 0,
            recipientAdd = 1,
            recipientRemove = 2,
            call = 3,
            channelNameChange = 4,
            channelIconchange = 5,
            pinnedMessage = 6,
            memberJoin = 7,
            premiumGuildSubscription = 8,
            premiumGuildSubscriptionTier1 = 9,
            premiumGuildSubscriptionTier2 = 10,
            premiumGuildSubscriptionTier3 = 11,
        },

        relationshipType = {
            none = 0,
            friend = 1,
            blocked = 2,
            pendingIncoming = 3,
            pendingOutgoing = 4,
        },

        activityType = {
            default = 0,
            streaming = 1,
            listening = 2,
            custom = 4,
        },

        status = {
            online = "online",
            idle = "idle",
            doNotDisturb = "dnd",
            invisible = "invisible",
        },

        verificationLevel = {
            none = 0,
            low = 1,
            medium = 2,
            high = 3, -- (╯°□°）╯︵ ┻━┻
            veryHigh = 4, -- ┻━┻ ﾐヽ(ಠ益ಠ)ノ彡┻━┻
        },

        explicitContentLevel = {
            none = 0,
            medium = 1,
            high = 2,
        },

        premiumTier = {
            none = 0,
            tier1 = 1,
            tier2 = 2,
            tier3 = 3,
        },

        permission = {
            createInstantInvite = 0x00000001,
            kickMembers = 0x00000002,
            banMembers = 0x00000004,
            administrator = 0x00000008,
            manageChannels = 0x00000010,
            manageGuild = 0x00000020,
            addReactions = 0x00000040,
            viewAuditLog = 0x00000080,
            prioritySpeaker = 0x00000100,
            stream = 0x00000200,
            readMessages = 0x00000400,
            sendMessages = 0x00000800,
            sendTextToSpeech = 0x00001000,
            manageMessages = 0x00002000,
            embedLinks = 0x00004000,
            attachFiles = 0x00008000,
            readMessageHistory = 0x00010000,
            mentionEveryone = 0x00020000,
            useExternalEmojis = 0x00040000,
            connect = 0x00100000,
            speak = 0x00200000,
            muteMembers = 0x00400000,
            deafenMembers = 0x00800000,
            moveMembers = 0x01000000,
            useVoiceActivity = 0x02000000,
            changeNickname = 0x04000000,
            manageNicknames = 0x08000000,
            manageRoles = 0x10000000,
            manageWebhooks = 0x20000000,
            manageEmojis = 0x40000000,
        },

        messageFlag = {
            crossposted = 0x00000001,
            isCrosspost = 0x00000002,
            suppressEmbeds = 0x00000004,
            sourceMessageDeleted = 0x00000008,
            urgent = 0x00000010,
        },

        actionType = {
            guildUpdate = 1,
            channelCreate = 10,
            channelUpdate = 11,
            channelDelete = 12,
            channelOverwriteCreate = 13,
            channelOverwriteUpdate = 14,
            channelOverwriteDelete = 15,
            memberKick = 20,
            memberPrune = 21,
            memberBanAdd = 22,
            memberBanRemove = 23,
            memberUpdate = 24,
            memberRoleUpdate = 25,
            memberMove = 26,
            memberDisconnect = 27,
            botAdd = 28,
            roleCreate = 30,
            roleUpdate = 31,
            roleDelete = 32,
            inviteCreate = 40,
            inviteUpdate = 41,
            inviteDelete = 42,
            webhookCreate = 50,
            webhookUpdate = 51,
            webhookDelete = 52,
            emojiCreate = 60,
            emojiUpdate = 61,
            emojiDelete = 62,
            messageDelete = 72,
            messageBulkDelete = 73,
            messagePin = 74,
            messageUnpin = 75,
            integrationCreate = 80,
            integrationUpdate = 81,
            integrationDelete = 82,
        },

        logLevel = {
            none = 0,
            error = 1,
            warning = 2,
            info = 3,
            debug = 4,
        },
    },

    --todo class, extensions, package, storage
}

return Discordia