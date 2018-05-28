chai = require 'chai'
chai.use(require 'chai-as-promised')

Game = require '../src/coffee/game/game'

WorldBuilder = require '../src/coffee/game/world/builder'
World = require '../src/coffee/game/world/world'
Player = require '../src/coffee/game/player'
Character = require '../src/coffee/game/cards/characters/character'
Deck = require '../src/coffee/game/cards/deck'

PlainLandsCard = require '../src/coffee/game/cards/lands/plain' 
ForestLandsCard = require '../src/coffee/game/cards/lands/forest'
TownLandsCard = require '../src/coffee/game/cards/lands/town'

EncounterCard = require '../src/coffee/game/cards/encounters/encounter'
TavernBrawl = require '../src/coffee/game/cards/encounters/town/tavern-brawl'
FriendInNeed = require '../src/coffee/game/cards/encounters/town/friend-in-need'
ItemCard = require '../src/coffee/game/cards/items/item'
ItemBasicFood = require '../src/coffee/game/cards/items/food/basic-food'
ItemBasicDrink = require '../src/coffee/game/cards/items/drink/basic-drink'

TestUtil = require './lib/test-util'
MathUtil = require '../src/coffee/game/common/math-util'

MoveTurn = require '../src/coffee/game/gamestate/move'
TradeTurn = require '../src/coffee/game/gamestate/trade'

describe 'Game', ->
    fineBuilder = new WorldBuilder
    
    describe 'Initial state', ->
        it 'Should use given world builder', ->
            wrongBuilder = new WorldBuilder towns: 15, sizeX: 3, sizeY: 3
            chai.expect -> new Game wrongBuilder
                .to.throw()

            chai.expect -> new Game fineBuilder
                .to.not.throw()

        it 'Should use given world object', ->
            tiles = [
                [ null,                             null,                               new TownLandsCard(x: 2, y: 0) ]
                [ new TownLandsCard(x: 0, y: 1),    new ForestLandsCard(x: 1, y: 1),    new PlainLandsCard(x: 2, y: 1) ]
                [ null,                             null,                               null ]
            ]
            towns =  [
                { x: 0, y: 1 }
                { x: 2, y: 0 }
            ]
            world = new World tiles, towns
            game = null
            chai.expect(-> game = new Game world).to.not.throw()
            chai.expect(game.world instanceof World).to.be.true
            

        it 'Should use given card cfg', ->
            registry = 
                encounters: {}
            
            registry.encounters[ForestLandsCard] = [
                TavernBrawl
            ]

            limitedBuilder = new WorldBuilder
                availableLands: [
                    { ctor: ForestLandsCard, weight: 1 }
                ]  

            game = new Game fineBuilder, registry
            chai.expect(game.encounterDecks[ForestLandsCard].stack.map (encounter) -> encounter.constructor).to.deep.equal [ TavernBrawl ]

        describe 'Encounter decks', ->
            it 'Should have a deck for each terrain type in the world', ->
                TestUtil.testFailCount 3, ->
                    builder = new WorldBuilder
                        towns: 10
                        availableLands: [
                            { ctor: ForestLandsCard, weight: 1 }
                            { ctor: PlainLandsCard, weight: 1 }
                        ]
                    game = new Game builder

                    # We expect an encounter for each of the lands type + towns
                    chai.expect(Object.keys(game.encounterDecks).length).to.equal 3

            it 'Should only contain the appropariate configurable cards', ->
                TestUtil.testFailCount 3, ->
                    landsConfig = [
                            { ctor: ForestLandsCard, weight: 1 }
                            { ctor: PlainLandsCard, weight: 1 }
                    ]
                    builder = new WorldBuilder
                        towns: 10
                        availableLands: landsConfig
                
                    registry = 
                        encounters: {}

                    registry.encounters[TownLandsCard] = [
                        FriendInNeed
                    ]
                    registry.encounters[ForestLandsCard] = [
                        TavernBrawl
                        FriendInNeed
                    ]
                    registry.encounters[PlainLandsCard] = [
                        TavernBrawl
                    ]
                    game = new Game builder, registry

                    for lands in landsConfig
                        for encounterCtor in registry.encounters[lands.ctor]
                            chai.expect(game.encounterDecks[lands.ctor].stack.every((encounter) -> registry.encounters[lands.ctor].indexOf(encounter.constructor) isnt -1))
                                .to.be.true
        
        describe 'Trade decks', ->    
            it 'Should have a trade deck for each of the towns in play', ->
                builder = new WorldBuilder
                    towns: 5
                game = new Game builder, null
                chai.expect(Object.keys(game.tradeDecks).length).to.equal 5

            it 'Should have only item cards in the deck', ->
                game = new Game fineBuilder 
                chai.expect game.tradeDecks.every (deck) ->
                    deck.stack.every (card) ->
                        card instanceof ItemCard
                .to.be.true
        
    describe 'Flow', ->
        builder = new WorldBuilder
        game = new Game builder
        
        it 'Should track game state', ->
            chai.expect(game.state).to.be.instanceof MoveTurn
            chai.expect(game.turnCount).to.equal 1

        it 'Should track players', ->
            chai.expect(game.players).to.exist
            chai.expect(Array.isArray game.players).to.be.true

            anotherGame = new Game builder, null, 5
            chai.expect(anotherGame.players.length).to.equal 5

        it 'Should always be played out by at least one player', ->
            chai.expect(game.players.length).to.equal 1

        it 'Should list available tiles for player to move to', ->
            game = new Game builder, null, 2 
            availableTiles = game.state.getAvailableTilesToMove()
            allTilesAreAdjacent = availableTiles.every (tile) -> MathUtil.areAdjacent(tile, game.state.player.pos)
            chai.expect(allTilesAreAdjacent).to.be.true

        it 'Should give the players and object to perform state-dependend actions', ->
            game = new Game builder, null, 1
            chai.expect(game.state).to.be.an.instanceof MoveTurn

        it 'Should switch states upon completion of turn', ->
            game = new Game builder, null, 2 
            chai.expect(game.state.player).to.exist
            chai.expect(game.state.player).to.equal game.players[0]
            firstState = game.state
            firstState.moveTo(firstState.getAvailableTilesToMove()[0])
            firstState.whenDone.then ->
                secondState = game.state
                chai.expect(secondState.player).to.equal game.players[1]
                secondState.moveTo(secondState.getAvailableTilesToMove()[0])
                secondState.whenDone.then ->
                    # Skipping the trade since no one can trade before turn 3
                    game.state.whenDone.then ->
                        # Skipping the worldsim state
                        game.state.whenDone.then ->
                            chai.expect(game.state.player).to.equal game.players[0]

        it 'Should start the players on the first town in the list', ->
            game = new Game builder, null, 2 
            townPos = game.world.getTowns()[0].pos

            # Works for generated worlds
            chai.expect(game.players.every (p) -> MathUtil.equalPoints p.pos, townPos).to.be.true

            tiles = [
                [ null,                             null,                               new TownLandsCard(x: 2, y: 0) ]
                [ new ForestLandsCard(x: 1, y: 1),  new TownLandsCard(x: 0, y: 1),      new PlainLandsCard(x: 2, y: 1) ]
                [ null,                             null,                               null ]
            ]
            towns =  [
                { x: 1, y: 1 }
                { x: 2, y: 0 }
            ]
            presetWorld = new World tiles, towns
            presetWorldGame = new Game presetWorld, null, 4
            presetTownPos = presetWorldGame.world.getTowns()[0].pos
            # Works for preset worlds
            chai.expect(presetWorldGame.players.every (p) -> MathUtil.equalPoints p.pos, presetTownPos).to.be.true

        it 'Should only allow movement to an adjacent non-null tile', ->
            tiles = [
                [ null,                             null,                               new TownLandsCard(x: 2, y: 0) ]
                [ new ForestLandsCard(x: 0, y: 1),  new TownLandsCard(x: 1, y: 1),      new PlainLandsCard(x: 2, y: 1) ]
                [ null,                             null,                               null ]
            ]
            towns =  [
                { x: 1, y: 1 }
                { x: 2, y: 0 }
            ]
            world = new World tiles, towns
            game = new Game world, null, 2
            # Moving to null-tiles is forbidden
            chai.expect(-> game.state.moveTo x: 1, y: 0).to.throw()
            chai.expect(-> game.state.moveTo x: 1, y: 2).to.throw()

            # Moving to a non-manhattan-adjacent tile is forbidden
            chai.expect(-> game.state.moveTo x: 2, y: 0).to.throw()

            # Moving to an adjacent tile is ok
            moveState = game.state
            console.log game.state.player.pos
            chai.expect(-> moveState.moveTo x: 2, y: 1).to.not.throw()
            moveState.whenDone.then ->
                # First player should have moved by that point
                chai.expect(MathUtil.equalPoints game.players[0].pos, { x: 2, y: 1 }).to.be.true

        it 'Should draw and play the top encounter when entering the appropariate tile', ->
            builder = new WorldBuilder 
                availableLands: [
                    { ctor: PlainLandsCard, weight: 1 }
                ]
                
                registry = 
                    encounters: {}

                dummyCalled = false
                dummyEncounterCtor = class
                    resolve: () ->
                        new Promise (resolve, reject) ->
                            dummyCalled = true
                            resolve()

                registry.encounters[TownLandsCard] = [ dummyEncounterCtor ]
                registry.encounters[PlainLandsCard] = [ dummyEncounterCtor ]

            game = new Game builder, registry, 1
            game.state.moveTo game.state.getAvailableTilesToMove()[0]
            chai.expect(dummyCalled).to.be.true
            chai.expect(game.encounterDecks[TownLandsCard].stack.length is 0 or game.encounterDecks[PlainLandsCard].stack.length is 0).to.be.true

        it 'Should go to TRADE state after all the players have moved and at least one is in the TOWN', ->
            builder = new WorldBuilder
            game = new Game builder, null, 2
            initialPosition = game.state.player.pos
            chai.expect(game.turnCount).to.equal 1
            game.state.moveTo game.state.getAvailableTilesToMove()[0]
            game.state.whenDone.then ->
                game.state.moveTo game.state.getAvailableTilesToMove()[0]
                game.state.whenDone.then ->
                    # Skipping the trade as no one is on the town tile
                    game.state.whenDone.then ->
                        # Skipping the worldsim as no input is required there
                        game.state.whenDone.then ->
                            # Expect move state now and turn count to be updated
                            chai.expect(game.state).to.be.instanceof MoveTurn
                            chai.expect(game.turnCount).to.equal 2

                            game.state.moveTo initialPosition
                            game.state.whenDone.then ->
                                # Expect move state since not all of the players are done with their movements
                                chai.expect(game.state).to.be.instanceof MoveTurn
                                game.state.moveTo initialPosition
                                game.state.whenDone.then ->
                                    # Finally should be trading since all of the players are done moving
                                    # and we have players in town
                                    chai.expect(game.turnCount).to.equal 2
                                    chai.expect(game.state).to.be.instanceof TradeTurn

describe 'Player', ->
    player = new Player

    it 'Should be an object', ->
        chai.expect(Array.isArray player).to.be.false
        chai.expect(typeof player).to.equal 'object'

    it 'Should have a WAGON deck, initially filled with food and drinks', ->
        chai.expect(player.wagon instanceof Deck).to.be.true
        chai.expect(player.wagon.stack.filter((item) -> item instanceof ItemBasicFood).length).to.equal 10
        chai.expect(player.wagon.stack.filter((item) -> item instanceof ItemBasicDrink).length).to.equal 10
        
    it 'Should have a party with at least current players character', ->
        chai.expect(Array.isArray player.party).to.be.true
        chai.expect(player.party.length).to.be.above 0
        chai.expect(player.party).to.include player.playerCharacter
        chai.expect(player.party.every (character) -> character instanceof Character).to.be.true