World = require './world'
MathUtil = require '../common/math-util'
TownLandsCard = require '../cards/lands/town'

defaultCfg = require '../cfg/worldgen.json'

module.exports = class WorldBuilder
    constructor: (@options) ->
        @options ?= defaultCfg
        @options.sizeX ?= defaultCfg.sizeX
        @options.sizeY ?= defaultCfg.sizeY
        @options.towns ?= defaultCfg.towns

    prepareTilesMatrix: () ->
        new Array(@options.sizeY) for column in [0..@options.sizeX-1]


    build: () ->
        tiles = @prepareTilesMatrix()
        @placeTowns tiles
        new World tiles

    placeTown: (tiles, town) ->
        tiles[town.y][town.x] = new TownLandsCard

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
                    @placeTown(tiles, town) for town in towns 
                    return

            regionRejects++
            if regionRejects is 10 then throw new Error('Couldnt place towns. Try reducing the amount of towns or increase the map size.')
