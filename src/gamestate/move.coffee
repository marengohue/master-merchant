MathUtil = require '../common/math-util'

Turn = require './turn'
TradeTurn = require './trade'

module.exports = class MoveTurn extends Turn
    getNextState: ->
        if @isLastPlayersTurn()
            @getTradeOrWorldsim()
        else
            @getNextPlayerMoveTurn()

    isLastPlayersTurn: ->
        @player is @game.players[@game.playerCount - 1]

    getTradeOrWorldsim: ->
        firstPlayerInTradeState = @game.players.findIndex (p) => @game.world.getTile(p.pos) instanceof TownLandsCard
        new TradeTurn @players[firstPlayerInTradeState], @

    getNextPlayerMoveTurn: ->
        new TradeMove @players[@game.players.findIndex(@player) + 1], @game

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