require './common/reflect'

WorldBuilder = require './world/builder'
GameState = require './common/state'
Player = require './player'

Deck = require './cards/deck'

MathUtil = require './common/math-util'

module.exports = class Game
    constructor: (worldOrBuilder, @cardRegistry, @playerCount = 1) ->
        @cardRegistry ?= require './cfg/card-registry'
        @world = if worldOrBuilder instanceof WorldBuilder then worldOrBuilder.build() else worldOrBuilder
        @buildEncounterDecks()
        @buildTownTradeDecks()
        @state = GameState.MOVEMENT
        @turnCount = 1
        @players = for playerNo in [1..@playerCount] then new Player(@world.towns[0].pos)
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

    cyclePlayers: ->
        @currentPlayerNo = if @currentPlayerNo + 1 is @playerCount then 0 else @currentPlayerNo + 1

    getAvailableTilesToMove: ->
        if @state is GameState.MOVEMENT
            MathUtil
                .getNeighbours @currentPlayer.pos
                .filter (p) => @world.getTile(p)?
        else
            [ ]

    resolveEncounter: ->
        playerTile = @world.getTile @currentPlayer.pos
        encounter = @encounterDecks[playerTile.constructor].getTop()
        if encounter? then encounter.resolve() else Promise.resolve(null)

    performMove: (toWhere) ->
        if @state is GameState.MOVEMENT
            if MathUtil.areAdjacent(@currentPlayer.pos, toWhere) and @world.getTile(toWhere)?
                @currentPlayer.pos = toWhere
                @resolveEncounter().then =>
                    @cyclePlayers()
            else
                throw new Error 'Invalid movement'