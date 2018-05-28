Turn = require './turn'
WorldSimTurn = require './world-sim'

TownLandsCard = require '../cards/lands/town'

module.exports = class TradeTurn extends Turn
    constructor: (@player, game) ->
        super game
        if not @player?
            @player = TradeTurn.findNextPlayerToTrade null, game
            if not @player?
                @endTurn()

    @findNextPlayerToTrade: (currentPlayer, game) ->
        loop
            nextPlayer = game.getNextPlayer nextPlayer
            if not nextPlayer?
                return null
            else if game.world.getTile nextPlayer.pos instanceof TownLandsCard
                return nextPlayer
            
    getNextState: ->
        nextPlayerToTrade = TradeTurn.findNextPlayerToTrade @player, @game
        if nextPlayerToTrade?
            new TradeTurn nextPlayerToTrade, @game
        else
            new WorldSimTurn @game