module.exports = class MoveState
    constructor: (@player, @game) ->
    
    resolveEncounter: ->
        playerTile = @game.world.getTile @player.pos
        encounter = @game.encounterDecks[playerTile.constructor].getTop()
        if encounter? then encounter.resolve() else Promise.resolve(null)

    isValidMovement: (toWhere) ->
        MathUtil.areAdjacent(@currentPlayer.pos, toWhere) and @world.getTile(toWhere)?

    getAvailableTilesToMove: ->
        MathUtil
            .getNeighbours @player.pos
            .filter((p) => @game.world.getTile(p)?)

    moveTo: (toWhere) ->
        new Promise(resolve, reject) =>
            if @isValidMovement toWhere
                @player.pos = toWhere
                @resolveEncounter().then =>
                    resolve()
    