LandsCard = require '../cards/lands/lands'
Printer = require '../common/printer'

module.exports = class
    constructor: (@tiles, towns) ->
        @towns = towns.map (t) => @getTile t

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

    getTowns: ->
        @towns