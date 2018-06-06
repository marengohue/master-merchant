EventEmitter = require 'events'

WorldBuilder = require './world/builder.coffee'
Player = require './player.coffee'

Deck = require './cards/deck.coffee'
TownLandsCard = require './cards/lands/town.coffee'

MathUtil = require './common/math-util.coffee'

MoveTurn = require './gamestate/move.coffee'


module.exports = class Game extends EventEmitter
    constructor: (worldOrBuilder, @cardRegistry, @playerCount = 1) ->
        super()
        @cardRegistry ?= require './cfg/card-registry.coffee'
        @world = if worldOrBuilder instanceof WorldBuilder then worldOrBuilder.build() else worldOrBuilder
        @buildEncounterDecks()
        @buildTownTradeDecks()
        @players = for playerNo in [1..@playerCount] then new Player(@world.towns[0].pos)
        @turnCount = 1
        @state = new MoveTurn @players[0], @
        @state.whenDone.then => @processStateTransition()

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
        @state = @state.getNextState()
        @emit('stateChange', @state)
        @state.whenDone.then => @processStateTransition()
