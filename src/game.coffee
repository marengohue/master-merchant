WorldBuilder = require './world/builder'
Deck = require './cards/deck'

module.exports = class Game
    constructor: (worldBuilder, @cardRegistry) ->
        @cardRegistry ?= require './cfg/card-registry'
        @world = worldBuilder.build()
        @buildEncounterDecks()

    buildEncounterDecks: ->
        @encounterDecks = {}
        @world.getTileTypes().forEach((ctorType) => @buildEncounterDeck(ctorType))

    buildEncounterDeck: (ctor) ->
        @encounterDecks[ctor] = new Deck @cardRegistry.encounters[ctor]