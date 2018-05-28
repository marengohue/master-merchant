Turn = require './turn.coffee'

module.exports = class WorldSimTurn extends Turn
    constructor: (game) ->
        super game
        @endTurn()

    getNextState: ->
        @game.finishTurn()