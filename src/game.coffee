require './common/reflect'

WorldBuilder = require './world/builder'
GameState = require './common/state'
Player = require './player'

Deck = require './cards/deck'
TownLandsCard = require './cards/lands/town'

MathUtil = require './common/math-util'

MoveTurn = require './gamestate/move'

module.exports = class Game
    constructor: (worldOrBuilder, @cardRegistry, @playerCount = 1) ->
        @cardRegistry ?= require './cfg/card-registry'
        @world = if worldOrBuilder instanceof WorldBuilder then worldOrBuilder.build() else worldOrBuilder
        @buildEncounterDecks()
        @buildTownTradeDecks()
        @players = for playerNo in [1..@playerCount] then new Player(@world.towns[0].pos)
        @turnCount = 1
        @_state = new MoveTurn @players[0], @
        @_state.whenDone.then => @processStateTransition()

    @get 'state', ->
        @_state

    buildEncounterDecks: ->
        @encounterDecks = {}
        @world.getTileTypes().forEach((ctorType) => @buildEncounterDeck(ctorType))

    buildEncounterDeck: (ctor) ->
        encounterConstructors = @cardRegistry.encounters[ctor] or []
        @encounterDecks[ctor] = new Deck (encounterConstructors.map((encounter) -> new encounter))

    buildTownTradeDecks: ->
        itemCtors = @cardRegistry.items or []
        @tradeDecks = @world.getTowns().map (town) =>
            new Deck (itemCtors.map (itemCtor) -> new itemCtor)

    finishTurn: ->
        @turnCount += 1
        new MoveTurn @players[0], @

    getNextPlayer: (currentPlayer) ->
        if currentPlayer?    
            playerIndex = @players.indexOf currentPlayer
            throw new Error('This is not a player from the current game') if playerIndex is -1
            @players[playerIndex + 1] or null
        else
            @players[0]

    processStateTransition: ->
        @_state = @_state.getNextState()
        @_state.whenDone.then => @processStateTransition()
