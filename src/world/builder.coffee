World = require './world'
MathUtil = require '../common/math-util'

module.exports = class WorldBuilder
    constructor: (@options) ->
        @options ?= { }
        @options.sizeX ?= 15
        @options.sizeY ?= 15

    prepareTilesMatrix: () ->
        new Array @options.sizeY
            .fill(new Array @options.sizeX)

    build: () ->
        tiles = @prepareTilesMatrix()
        @placeTowns tiles, 100
        new World tiles

    placeTowns: (tiles, tries) ->
        towns = []
        loop
            tries -= 1
            if (tries is 0) then throw new Error("Couldn't place towns. Max tries exceeded")
            newTown = MathUtil.randomPoint @options.sizeX, @options.sizeY
            console.log('dsd',  MathUtil.manhattanDistance(newTown, MathUtil.randomPoint(10, 10)) )
            towns.push if towns.every((town) -> MathUtil.manhattanDistance(newTown, town) > 2)
            break if (towns.length is @options.towns)
        
        for town in towns then console.log town