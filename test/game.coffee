chai = require 'chai'

Game = require '../src/game'
WorldBuilder = require '../src/world/builder'

PlainLandsCard = require '../src/cards/lands/plain' 
ForestLandsCard = require '../src/cards/lands/forest'
TownLandsCard = require '../src/cards/lands/town'
TavernBrawl = require '../src/cards/encounters/town/tavern-brawl'
FriendInNeed = require '../src/cards/encounters/town/friend-in-need'
ItemCard = require '../src/cards/items/item'

TestUtil = require './lib/test-util'

describe 'Game', ->
    fineBuilder = new WorldBuilder

    it 'Should use given world builder', ->
        wrongBuilder = new WorldBuilder towns: 15, sizeX: 3, sizeY: 3
        chai.expect -> new Game wrongBuilder
            .to.throw()

        chai.expect -> new Game fineBuilder
            .to.not.throw()

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

        it 'Should have a trade deck full of item cards', ->
            game = new Game fineBuilder 
            chai.expect game.tradeDecks.every (deck) ->
                deck.stack.every (card) ->
                    card instanceof ItemCard
            .to.be.true