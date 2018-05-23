WorldBuilder = require './world/builder'
Deck = require './cards/deck'

module.exports = class Game
    constructor: (worldBuilder, @cardRegistry) ->
        @cardRegistry ?= require './cfg/card-registry'
        @world = worldBuilder.build()
        @buildEncounterDecks()
        @buildTownTradeDecks()

    buildEncounterDecks: ->
        @encounterDecks = {}
        @world.getTileTypes().forEach((ctorType) => @buildEncounterDeck(ctorType))

    buildEncounterDeck: (ctor) ->
        @encounterDecks[ctor] = new Deck @cardRegistry.encounters[ctor]

    buildTownTradeDecks: ->
        itemCtors = @cardRegistry.items or []
        @tradeDecks = @world.getTowns().map (town) =>
            new Deck (itemCtors.map (itemCtor) -> new itemCtor)