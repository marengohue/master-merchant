require './common/reflect'

WorldBuilder = require './world/builder'
GameState = require './common/state'
Player = require './player'

Deck = require './cards/deck'
TownLandsCard = require './cards/lands/town'

MathUtil = require './common/math-util'

MoveState = require './gamestate/move'

module.exports = class Game
    constructor: (worldOrBuilder, @cardRegistry, @playerCount = 1) ->
        @cardRegistry ?= require './cfg/card-registry'
        @world = if worldOrBuilder instanceof WorldBuilder then worldOrBuilder.build() else worldOrBuilder
        @buildEncounterDecks()
        @buildTownTradeDecks()
        @players = for playerNo in [1..@playerCount] then new Player(@world.towns[0].pos)
        @currentPlayerNo = 0
        @turnCount = 1
        @state = new MoveState @players[0], @

    @get 'currentPlayer', -> @players[@currentPlayerNo]

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

    cyclePlayers: ->
        @currentPlayerNo = if @currentPlayerNo + 1 is @playerCount then 0 else @currentPlayerNo + 1

    tryGoToWorldSimState: ->
        new Promise (resolve, reject) =>
            @state = GameState.SIMULATION
            @finishTurn().then =>
                resolve()

    tryGoToTradeState: ->
        new Promise (resolve, reject) =>
            if @currentPlayer is @players[0]
                firstPlayerInTradeState = @players.findIndex (p) => @world.getTile(p.pos) instanceof TownLandsCard
                if firstPlayerInTradeState isnt -1
                    @currentPlayerNo = firstPlayerInTradeState
                    @state = GameState.TRADE
                    resolve()
                else
                    @tryGoToWorldSimState().then =>
                        resolve()
            else
                resolve()

    finishTurn: ->
        new Promise (resolve, reject) =>
            @currentPlayerNo = 0
            @turnCount += 1
            @state = GameState.MOVEMENT
            resolve()

    processStateTransition: ->


    getState: ->
        @state