# Description
#   Context-based Group @mentions / Aliases
#
# Configuration:
#   None
#
# Commands:
#   cc new-channel <alias> <users...> - Creates a new @<alias> to @mention all <users...> (space separated) in the context of the current room / channel
#   cc new-global <alias> <users...> - Creates a new @<alias> to @mention all <users...> (space separated) in any context
#
# Notes:
#   None
#
# Author:
#   MrSaints

module.exports = (robot) ->
    _global = {}
    _channels = {}

    ERR_NOT_ENOUGH_USERS = (alias) ->
        "Please specify more than one user to be associated with @#{alias}."

    _saveAliases = ->
        robot.brain.data.cc =
            global: _global
            channels: _channels
        robot.logger.debug "hubot-cc: saving aliases to brain"
        robot.brain.save()

    _addAlias = (alias, users, channel = false) ->
        ctx = _global
        if channel
            _channels[channel] or= {}
            ctx = _channels[channel]
        robot.logger.debug "hubot-cc: creating / updating an alias (\"#{alias}\")"
        ctx[alias] = users
        _saveAliases()

    _getMentions = (alias, channel = false) ->
        ctx = _global
        ctx = _channels[channel] if channel
        return false unless ctx?[alias]?
        "cc: @" + ctx[alias].join(" @")

    robot.brain.on "loaded", ->
        data = robot.brain.data.cc
        return unless data?
        robot.logger.debug "hubot-cc: loading global aliases -> #{JSON.stringify(data.global)}"
        _global = data.global
        robot.logger.debug "hubot-cc: loading channel aliases -> #{JSON.stringify(data.channels)}"
        _channels = data.channels

    robot.respond /cc new-channel ([a-zA-Z0-9]+) (.+)/i, id: "cc.new.channel", (res) ->
        channel = res.message.user.room
        alias = res.match[1]
        users = res.match[2].split(" ")
        return res.reply ERR_NOT_ENOUGH_USERS(alias) if users.length < 2
        _addAlias(alias, users, channel)
        res.reply "The @#{alias} alias has now been added / updated for \"#{channel}\". Try it out!"

    robot.respond /cc new-global ([a-zA-Z0-9]+) (.+)/i, id: "cc.new.global", (res) ->
        alias = res.match[1]
        users = res.match[2].split(" ")
        return res.reply ERR_NOT_ENOUGH_USERS(alias) if users.length < 2
        _addAlias(alias, users)
        res.reply "The @#{alias} alias has now been added / updated. Try it out!"

    robot.receiveMiddleware (ctx, next, done) ->
        if match = ctx.response.message.text?.match(/\B@([a-zA-Z0-9]+)/i)
            channel = ctx.response.message.user.room
            alias = match[1]
            if local = _getMentions(alias, channel)
                ctx.response.send local
            if global = _getMentions(alias)
                ctx.response.send global
        next(done)