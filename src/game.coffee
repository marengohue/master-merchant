require './common/reflect'

WorldBuilder = require './world/builder'
GameState = require './common/state'
Player = require './player'

Deck = require './cards/deck'

module.exports = class Game
    constructor: (worldBuilder, @cardRegistry, @playerCount = 1) ->
        @cardRegistry ?= require './cfg/card-registry'
        @world = worldBuilder.build()
        @buildEncounterDecks()
        @buildTownTradeDecks()
        @state = GameState.MOVEMENT
        @turnCount = 1
        @players = for playerNo in [1..@playerCount] then new Player()
        @currentPlayerNo = 0

    @get 'currentPlayer', -> @players[@currentPlayerNo]

    buildEncounterDecks: ->
        @encounterDecks = {}
        @world.getTileTypes().forEach((ctorType) => @buildEncounterDeck(ctorType))

    buildEncounterDeck: (ctor) ->
        @encounterDecks[ctor] = new Deck @cardRegistry.encounters[ctor]

    buildTownTradeDecks: ->
        itemCtors = @cardRegistry.items or []
        @tradeDecks = @world.getTowns().map (town) =>
            new Deck (itemCtors.map (itemCtor) -> new itemCtor)

    performMove: ->
        if @state is GameState.MOVEMENT
            @currentPlayerNo = if @currentPlayerNo + 1 is @playerCount then 0 else @currentPlayerNo + 1