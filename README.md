# hubot-cc

[![Build Status](https://travis-ci.org/ClaudeBot/hubot-cc.svg)](https://travis-ci.org/ClaudeBot/hubot-cc)
[![devDependency Status](https://david-dm.org/ClaudeBot/hubot-cc/dev-status.svg)](https://david-dm.org/ClaudeBot/hubot-cc#info=devDependencies)

A Hubot script for defining aliases to easily @mention groups of people in a room or a global context.

See [`src/cc.coffee`](src/cc.coffee) for full documentation.


## Installation via NPM

1. Install the **hubot-cc** module as a Hubot dependency by running:

    ```
    npm install --save hubot-cc
    ```

2. Enable the module by adding the **hubot-cc** entry to your `external-scripts.json` file:

    ```json
    [
        "hubot-cc"
    ]
    ```

3. Run your bot and see below for available config / commands


## Commands

Command | Listener ID | Description
--- | --- | ---
hubot cc new-channel `alias` `users...` | `cc.new.channel` | Creates a new @`alias` to @mention all `users...` (space separated) in the context of the current room / channel
hubot cc new-global `alias` `users...` | `cc.new.global` | Creates a new @`alias` to @mention all `users...` (space separated) in any context
cc remove `alias` | `cc.remove` | Removes @`alias` from the current, and the global context
cc list | `cc.list` | Returns all defined aliases

### Contexts

The difference between `new-channel`, and `new-global` is that aliases created using the former (`new-channel`) can only be triggered in the room / channel (context) that it was created in. Aliases created using the latter (`new-global`) however, can be triggered in any context as long as the bot is present in it.

If there is an alias defined with the same name in a local (room / channel), and a global context, both of them _may be triggered_ at the same time.


## Sample Interaction

```
user1>> hubot cc new-global admins user1 user2 user3
hubot>> user1: The @admins alias has now been added / updated. Try it out!
user1>> Hello @admins!
hubot>> cc: @user1 @user2 @user3
```
