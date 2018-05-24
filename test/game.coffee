chai = require 'chai'

Game = require '../src/game'
GameState = require '../src/common/state'

WorldBuilder = require '../src/world/builder'
World = require '../src/world/world'
Player = require '../src/player'
Character = require '../src/character'
Deck = require '../src/cards/deck'

PlainLandsCard = require '../src/cards/lands/plain' 
ForestLandsCard = require '../src/cards/lands/forest'
TownLandsCard = require '../src/cards/lands/town'

EncounterCard = require '../src/cards/encounters/encounter'
TavernBrawl = require '../src/cards/encounters/town/tavern-brawl'
FriendInNeed = require '../src/cards/encounters/town/friend-in-need'
ItemCard = require '../src/cards/items/item'
ItemBasicFood = require '../src/cards/items/food/basic-food'
ItemBasicDrink = require '../src/cards/items/drink/basic-drink'

TestUtil = require './lib/test-util'
MathUtil = require '../src/common/math-util'

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
            chai.expect(game.encounterDecks[ForestLandsCard].stack).to.deep.equal [ TavernBrawl ]

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
                        for card in registry.encounters[lands.ctor]
                            chai.expect(game.encounterDecks[lands.ctor]).to.contain(card)
        
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
            chai.expect(game.state).to.equal GameState.MOVEMENT
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
            availableTiles = game.getAvailableTilesToMove()
            allTilesAreAdjacent = availableTiles.every (tile) -> MathUtil.areAdjacent(tile, game.currentPlayer.pos)
            chai.expect(allTilesAreAdjacent).to.be.true

        it 'Should allow players to move one by one', ->
            game = new Game builder, null, 2 
            chai.expect(game.currentPlayer).to.exist
            chai.expect(game.currentPlayer).to.equal game.players[0]
            game.performMove(game.getAvailableTilesToMove()[0])
            chai.expect(game.currentPlayer).to.equal game.players[1]
            game.performMove(game.getAvailableTilesToMove()[0])
            chai.expect(game.currentPlayer).to.equal game.players[0]

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
            chai.expect(-> game.performMove x: 1, y: 0).to.throw()
            chai.expect(-> game.performMove x: 1, y: 2).to.throw()

            # Moving to a non-manhattan-adjacent tile is forbidden
            chai.expect(-> game.performMove x: 2, y: 0).to.throw()

            # Moving to an adjacent tile is ok
            chai.expect ->
                game.performMove x: 0, y: 1
            .to.not.throw()

            # First player should have moved by that point
            chai.expect(MathUtil.equalPoints game.players[0].pos, { x: 0, y: 1 }).to.be.true

        it 'Should draw and play the top encounter when entering the appropariate tile', ->
            builder = new WorldBuilder 
                availableLands: [
                    { ctor: PlainLandsCard, weight: 1 }
                ]
                
                registry = 
                    encounters: {}

                dummyCalled = false
                dummyEncounter = Object.create
                    resolve: () ->
                        new Promise (resolve, reject) ->
                            dummyCalled = true
                            resolve()

                registry.encounters[TownLandsCard] = [ dummyEncounter ]
                registry.encounters[PlainLandsCard] = [ dummyEncounter ]

            game = new Game builder, registry, 1
            game.performMove game.getAvailableTilesToMove()[0]
            chai.expect(dummyCalled).to.be.true
            chai.expect(game.encounterDecks[TownLandsCard].stack.length).to.be(0).or.expect(game.encounterDecks[PlainLandsCard].stack.length).to.be(0)


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