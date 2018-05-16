World = require './world'
MathUtil = require '../common/math-util'
TownLandsCard = require '../cards/lands/town'
LandsCard = require '../cards/lands/lands'

PlainLandsCard = require '../cards/lands/plain'
ForestLandsCard = require '../cards/lands/forest'
RiverLandsCard = require '../cards/lands/river'

defaultCfg = require '../cfg/worldgen.json'

module.exports = class WorldBuilder
    constructor: (@options) ->
        @options ?= defaultCfg
        @options.sizeX ?= defaultCfg.sizeX
        @options.sizeY ?= defaultCfg.sizeY
        @options.towns ?= defaultCfg.towns
        @options.availableLands ?= [
            { ctor: PlainLandsCard, weight: 10 }
            { ctor: ForestLandsCard, weight: 5 }
            { ctor: RiverLandsCard, weight: 1 }
        ]
        @applyWeightToLands()

    applyWeightToLands: () ->
        landsRandomizerCoefficient = @options.availableLands
            .reduce ((acc, val) => acc + val.weight), 0
        prevWeight = 0
        @options.availableLands
            .forEach (landsRegistryObj) =>
                prevWeight += landsRegistryObj.weight / landsRandomizerCoefficient
                landsRegistryObj.weight = prevWeight

    prepareTilesMatrix: () ->
        new Array(@options.sizeX).fill(null) for column in [0..@options.sizeY-1]

    build: () ->
        tiles = @prepareTilesMatrix()
        towns = @placeTowns tiles
        @connectTowns tiles, towns
        new World tiles, towns

    placeTown: (tiles, town) ->
        tiles[town.y][town.x] = new TownLandsCard town

    placeTowns: (tiles) ->
        regionRejects = 0
        loop
            towns = []
            triesLeft = 1 + @options.sizeY * @options.sizeX
            
            while triesLeft > 0
                triesLeft -= 1
                newTown = MathUtil.randomPoint @options.sizeX, @options.sizeY
                towns.push(newTown) if towns.every((town) -> MathUtil.manhattanDistance(newTown, town) > 2)
                if (towns.length is @options.towns)
                    for town in towns then @placeTown(tiles, town)
                    return towns

            regionRejects++
            if regionRejects is 10 then throw new Error('Couldnt place towns. Try reducing the amount of towns or increase the map size.')

    connectAdjacentTowns: (tiles, connectedTowns, x, y) ->
        MathUtil.getNeighbours({x, y})
                .map (p) ->
                    row = tiles[p.y]
                    if row then row[p.x] or null else null
                .filter (tile) -> tile? and tile instanceof TownLandsCard and connectedTowns.indexOf(tile) is -1
                .forEach (town) -> connectedTowns.push town

    randomLandsAt: (x, y) ->
        landsRoll = Math.random();
        for registryObj in @options.availableLands
            if (registryObj.weight >= landsRoll)
                return new registryObj.ctor {x, y}

        throw new Error 'Couldnt pick a random lands card'

    placeSingleLands: (tiles, connectedTowns, x, y) ->
        existingTile = tiles[y][x]
        unless existingTile?
            tiles[y][x] = @randomLandsAt x, y
            @connectAdjacentTowns tiles, connectedTowns, x, y

    drawLandsLine: (tiles, connectedTowns, p0, p1) ->
        for y in [p0.y..p1.y]
            @placeSingleLands tiles, connectedTowns, p0.x, y

        for x in [p0.x..p1.x]
            @placeSingleLands tiles, connectedTowns, x, p1.y

    connectTwoTowns: (tiles, connectedTowns, t0, t1) ->
        if Math.random() > 0.5
            @drawLandsLine tiles, connectedTowns, t0, t1
        else
            @drawLandsLine tiles, connectedTowns, t1, t0

    connectTowns: (tiles, townsToConnect) ->
        townsToConnect = townsToConnect.slice()
        connectedTowns = [ ]
        t0 = townsToConnect.pop()
        t1 = townsToConnect.pop()        
        @connectTwoTowns tiles, connectedTowns, t0, t1
        while townsToConnect.length > 0
            t0 = t1
            t1 = townsToConnect.pop()
            if (connectedTowns.find (t) -> MathUtil.equalPoints t1, t.pos)? then continue
            @connectTwoTowns tiles, connectedTowns, t0, t1
