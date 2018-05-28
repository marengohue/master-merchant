LandsCard = require '../cards/lands/lands.coffee'
Printer = require '../common/printer.coffee'

module.exports = class
    constructor: (@tiles, towns) ->
        @towns = towns.map (t) => @getTile t
        @initTileTypes()

    getTile: (xOrP, y) ->
        if y?
            row = @tiles[y]
            if row then row[xOrP] or null else null
        else if xOrP.x? and xOrP.y?
            @getTile xOrP.x, xOrP.y
        
    getSize: ->
        {
            x: @tiles.length
            y: @tiles[0].length or 0
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