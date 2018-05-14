chai = require 'chai'

describe 'WorldBuilder', () ->
    World = require '../src/world/world'
    WorldBuilder = require '../src/world/builder'
    bareBuilder = new WorldBuilder

    it 'Should be an object', ->
        chai.expect(Array.isArray bareBuilder).to.be.false
        chai.expect(typeof bareBuilder).to.equal 'object'

    describe '.build', ->
        countTiles = (world, predecate) ->
            size = world.getSize()
            count = 0
            for x in [0..size.x - 1]
                for y in [0..size.y - 1]
                    if (predecate(world.getTile x, y)) then inc count
            count
            
        it 'Should be a function', ->
            chai.expect(typeof bareBuilder.build).to.equal 'function'

        it 'Should yield a world when called', ->
            chai.expect(bareBuilder.build() instanceof World).to.be.true

        it 'Should provide default minimal options', ->
            defaultWorld = bareBuilder.build()
            chai.expect(defaultWorld.getSize()).to.deep.equal { x: 5, y: 5 }

        it 'Should build the world that has certain size', ->
            testBuilder = new WorldBuilder { sizeX: 10, sizeY: 10 }
            chai.expect(testBuilder.build().getSize()).to.deep.equal { x: 10, y: 10 }

        it 'Should build the world that has a certain number of towns', ->
            TownLandsCard = require '../src/cards/lands/town'
            testBuilder = new WorldBuilder { towns: 5 }
            testWorld = testBuilder.build()
            chai.expect(countTiles(testWorld, (land) -> land instanceof TownLandsCard)).to.equal 5

describe 'World', () ->
    LandsCard = require '../src/cards/lands/lands'
    World = require '../src/world/world'
    world = new World([
        [ new LandsCard, new LandsCard, new LandsCard ],
        [ new LandsCard, new LandsCard, new LandsCard ]
        [ new LandsCard, new LandsCard, new LandsCard ]
    ])
    
    it 'Should be an object', ->
        chai.expect(Array.isArray world).to.be.false
        chai.expect(typeof world).to.equal 'object'

    describe '.getTile', ->
        it 'Should be a function', ->
            chai.expect(typeof world.getTile).to.equal 'function'
        
        it 'Should yield a lands when given coords', ->
            chai.expect(world.getTile(1, 1) instanceof LandsCard).to.be.true

        it 'Should yield null when out of the bounds', ->
            chai.expect(world.getTile 10, 0).to.be.null
            chai.expect(world.getTile 0, 10).to.be.null
            chai.expect(world.getTile -10, 0).to.be.null
            chai.expect(world.getTile 0, -10).to.be.null

        it 'Should yield the same lands when called multiple times with same coord', ->
            chai.expect(world.getTile 1, 1).to.equal(world.getTile 1, 1)
            chai.expect(world.getTile 1, 10).to.equal(world.getTile 1, 10)

        