LandsCard = require '../cards/lands/lands.coffee'
TownLandsCard = require '../cards/lands/town.coffee'
Printer = require '../common/printer.coffee'

module.exports = class
    constructor: (@tiles) ->
        @initFlatTiles()
        @towns = @flatTiles.filter (tile) -> tile instanceof TownLandsCard
        @initTileTypes()

    getTile: (xOrP, y) ->
        if y?
            row = @tiles[y]
            if row then row[xOrP] or null else null
        else if xOrP.x? and xOrP.y?
            @getTile xOrP.x, xOrP.y
        
    initFlatTiles: ->
        @flatTiles = []
        for row in @tiles
            for tile in row
                if tile? then @flatTiles.push tile

    getFlatTiles: ->
        @flatTiles

    getSize: ->
        {
            x: @tiles[0].length or 0
            y: @tiles.length
        }

    toString: ->
        Printer.printWorldTiles @tiles

    initTileTypes: ->
        @tileTypes = []
        for row in @tiles
            for tile in row
                if tile? and @tileTypes.indexOf(tile.constructor) is -1 then @tileTypes.push tile.constructor

    getTileTypes: -> @tileTypes

    getTowns: -> @towns