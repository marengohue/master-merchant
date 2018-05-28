MathUtil = require '../common/math-util.coffee'

Turn = require './turn.coffee'
TradeTurn = require './trade.coffee'

module.exports = class MoveTurn extends Turn
    constructor: (@player, game) ->
        super game

    getNextState: ->
        nextPlayer = @game.getNextPlayer @player
        if nextPlayer?
            @getNextPlayerMoveTurn nextPlayer
        else
            @getTradeOrWorldsim()

    getTradeOrWorldsim: ->
        new TradeTurn null, @game

    getNextPlayerMoveTurn: (nextPlayer) ->
        new MoveTurn nextPlayer, @game

    resolveEncounter: ->
        playerTile = @game.world.getTile @player.pos
        encounter = @game.encounterDecks[playerTile.constructor].getTop()
        if encounter? then encounter.resolve() else Promise.resolve(null)

    isValidMovement: (toWhere) ->
        MathUtil.areAdjacent(@player.pos, toWhere) and @game.world.getTile(toWhere)?

    getAvailableTilesToMove: ->
        MathUtil
            .getNeighbours @player.pos
            .filter((p) => @game.world.getTile(p)?)

    moveTo: (toWhere) ->
        if @isValidMovement toWhere
            @player.pos = toWhere
            @resolveEncounter().then =>
                @endTurn()
        else
            throw new Error 'Invalid movement.'
