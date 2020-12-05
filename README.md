# fear-my-bot

Fear-My-Bot is a relatively basic framework for a Discord bot using Luvit and Discordia! Its main purpose is to act as a main place to provide bot-agonostic upgrades to the multiple bots I run and isn't really designed for anyone but myself. As a result, this file is rather short and doesn't go into many details.

## Why?

I run two discord bots with a few hundred users being served by both bots. One of them is a fullly fledged moderation bot and the other is a less serious bot, complete with puns. While maintaining these bots, a few issues became apparent:

- I had gotten much better at programming since I'd first started.
- One of them was on a much older version of Luvit and Discordia.
- Feature creep had gotten hold of them.
- They had diverged in design and features, making them a pain to maintain together.

With all those in mind, I decided to write a simple framework for Discord bots, both as practice and so that I could port the two bots to it. That framework is this.

## Notable Features

- Modular commands - All commands are isolated to their own files and are loaded when the bot initializes. You can just plop a new one in with no problems.
- Simple yet powerful permissions - By allowing permissions to be granular and be both per role and user, and per command, server admins are able to pick and choose what commands they want a user to be able to use.
- Error tolerant - If a command throws, it won't bring the entire bot down and instead the bot owner will be notified.
- Easy to configure - Changing settings for the bot is easy and servers each have their own settings file that can be manually adjusted (or adjusted with a command).

## Potential Issues

The [`restart`](libs/commands/command_files/internal/restart.lua) command uses a combination of `os.execute`, `jit.os`, and guesswork to restart the bot. If your OS has a better way to spawn a new process, feel free to contribute it, otherwise, you'll just have to make do. I test on Windows.
