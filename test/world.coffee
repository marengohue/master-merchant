chai = require 'chai'

World = require '../src/coffee/game/world/world'

LandsCard = require '../src/coffee/game/cards/lands/lands'
PlainLandsCard = require '../src/coffee/game/cards/lands/plain'
ForestLandsCard = require '../src/coffee/game/cards/lands/forest'
RiverLandsCard = require '../src/coffee/game/cards/lands/river'

TownLandsCard = require '../src/coffee/game/cards/lands/town'
WorldBuilder = require '../src/coffee/game/world/builder'
MathUtil = require '../src/coffee/game/common/math-util'
defaultCfg = require '../src/coffee/game/cfg/worldgen.json'

TestUtil = require './lib/test-util'

describe 'WorldBuilder', ->
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
                    if (predecate(world.getTile x, y)) then count++
            count
            
        alreadyTraversed = (traversed, p) ->
            traversed.some((p1) -> MathUtil.equalPoints(p, p1))

        it 'Should be a function', ->
            chai.expect(typeof bareBuilder.build).to.equal 'function'

        it 'Should yield a world when called', ->
            chai.expect(bareBuilder.build() instanceof World).to.be.true

        it 'Should provide default minimal options', ->
            defaultWorld = bareBuilder.build()
            chai.expect(defaultWorld.getSize().x).to.be.at.most defaultCfg.sizeX
            chai.expect(defaultWorld.getSize().y).to.be.at.most defaultCfg.sizeY

        it 'Should build the world that has certain size', ->
            testBuilder = new WorldBuilder { sizeX: 10, sizeY: 10 }
            worldSize = testBuilder.build().getSize()
            chai.expect(worldSize.x).to.be.at.most 10
            chai.expect(worldSize.y).to.be.at.most 10

        it 'Should build the world that has a certain number of towns', ->
            testBuilder = new WorldBuilder { towns: 5 }
            testWorld = testBuilder.build()
            countTowns = (land) ->
                land instanceof TownLandsCard
            chai.expect(countTiles(testWorld, countTowns)).to.equal 5

        it 'Should generate the map with all the towns connected', ->
            townsRemain = 25
            testBuilder = new WorldBuilder { towns: townsRemain }
            world = testBuilder.build()
            firstTown = world.getTowns()[0]
            pointsToTraverse = [ firstTown.pos ]
            traversed = [ ]
            while pointsToTraverse.length isnt 0
                nextPoint = pointsToTraverse.pop()
                traversed.push nextPoint
                tile = world.getTile nextPoint
                if (tile instanceof LandsCard)
                    if tile instanceof TownLandsCard then townsRemain -= 1
                    pointsToTraverse = pointsToTraverse.concat(
                        MathUtil
                            .getNeighbours(nextPoint)
                            .filter (p) -> not alreadyTraversed(traversed.concat(pointsToTraverse), p)
                    )

            chai.expect(townsRemain).to.equal 0

        it 'Should use only the given lands constructors when building world', ->
            sizeX = sizeY = 25
            testBuilder = new WorldBuilder
                availableLands: [
                    { ctor: PlainLandsCard, weight: 1 }
                    { ctor: ForestLandsCard, weight: 1 }
                ]
                sizeX
                sizeY
                towns: 0

            testWorld = testBuilder.build()
            chai.expect(countTiles testWorld, (tile) -> (not tile instanceof PlainLandsCard) and (not tile instanceof ForestLandsCard)).to.equal 0
        
        it 'Should respect the weights for the tile cards', ->
            TestUtil.testFailCount 5, ->
                sizeX = sizeY = 100
                testBuilder = new WorldBuilder
                    availableLands: [
                        { ctor: PlainLandsCard, weight: 10 }
                        { ctor: ForestLandsCard, weight: 2 }
                        { ctor: RiverLandsCard, weight: 1}
                    ]
                    sizeX
                    sizeY
                    towns: 0
                testWorld = testBuilder.build()

                plainsTilesCount = countTiles testWorld, (tile) -> (tile instanceof PlainLandsCard)
                forestTilesCount = countTiles testWorld, (tile) -> (tile instanceof ForestLandsCard)
                riverTilesCount = countTiles testWorld, (tile) -> (tile instanceof RiverLandsCard)
                totalTiles = plainsTilesCount + forestTilesCount + riverTilesCount

                chai.expect(Math.abs(plainsTilesCount / totalTiles - 10/13)).to.be.below(0.1)
                chai.expect(Math.abs(forestTilesCount / totalTiles - 2/13)).to.be.below(0.1)
                chai.expect(Math.abs(riverTilesCount / totalTiles - 1/13)).to.be.below(0.1)

        it 'Should trim the matrix to remove unnecessary rows and columns', ->
            TestUtil.testSuccessCount 5, ->
                testBuilder = new WorldBuilder 
                world = testBuilder.build()
                #First row has at least a single tile
                chai.expect(world.tiles[0].some((tile) -> !!tile)).to.be.true
                #Last row has at least a single tile
                chai.expect(world.tiles[world.tiles.length - 1].some((tile) -> !!tile)).to.be.true
                #First column has at least a single tile
                chai.expect(world.tiles.some((row) -> !!row[0])).to.be.true
                #Last column has at least a single tile
                chai.expect(world.tiles.some((row) -> !!row[row.length - 1])).to.be.true

        xit 'Should kinda look like a world map (not a real test)', ->
            testBuilder = new WorldBuilder sizeX: 100, sizeY: 50, towns: 100
            console.log(testBuilder.build().toString())

describe 'World', ->
    tiles = [
        [ null,                             null,                               new TownLandsCard(x: 2, y: 0) ]
        [ new TownLandsCard(x: 0, y: 1),    new ForestLandsCard(x: 1, y: 1),    new RiverLandsCard(x: 2, y: 1) ]
        [ null,                             null,                               null ]
    ]
    towns =  [
        { x: 0, y: 1 }
        { x: 2, y: 0 }
    ]
    world = new World tiles, towns
    
    it 'Should be an object', ->
        chai.expect(Array.isArray world).to.be.false
        chai.expect(typeof world).to.equal 'object'

    describe '.getTile', ->
        it 'Should be a function', ->
            chai.expect(typeof world.getTile).to.equal 'function'
        
        it 'Should yield a lands when given coords', ->
            chai.expect(world.getTile(1, 1) instanceof LandsCard).to.be.true

        it 'Should world with a single argument as a point obj', ->
            chai.expect(world.getTile(x: 1, y: 1)).to.equal(world.getTile(1, 1))

        it 'Should yield null when out of the bounds', ->
            chai.expect(world.getTile 10, 0).to.be.null
            chai.expect(world.getTile 0, 10).to.be.null
            chai.expect(world.getTile -10, 0).to.be.null
            chai.expect(world.getTile 0, -10).to.be.null

        it 'Should yield the same lands when called multiple times with same coord', ->
            chai.expect(world.getTile 1, 1).to.equal(world.getTile 1, 1)
            chai.expect(world.getTile 1, 10).to.equal(world.getTile 1, 10)


    describe '.getTowns', ->
        it 'Should be a function', ->
            chai.expect(typeof world.getTowns).to.equal 'function'
         
        it 'Should yield a list of towns', ->
            result = world.getTowns()
            chai.expect(Array.isArray result).to.be.true
            chai.expect(result.every (town) -> town instanceof TownLandsCard)
            chai.expect(result.length).to.equal 2

        it 'Should yield the appropariate town cards', ->
            chai.expect(world.getTowns()).to.deep.equal(towns.map((p) -> tiles[p.y][p.x]))

    describe '.getFlatTiles', ->
        it 'Should be a function', ->
            chai.expect(typeof world.getFlatTiles).to.equal 'function'

        it 'Should return a flat list of all non-null tiles', ->
            chai.expect(world.getFlatTiles().every((tile) -> world.getTile(tile.pos) is tile)).to.be.true

    describe '.getTileTypes', ->
        it 'Should be a function', ->
            chai.expect(typeof world.getTileTypes).to.equal 'function'

        it 'Should yield a list of all available tile types for the world', ->
            result = world.getTileTypes()
            for ctor in [ForestLandsCard, RiverLandsCard, TownLandsCard]
                chai.expect(result).to.include ctor