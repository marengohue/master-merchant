LandsCard = require '../cards/lands/lands'

module.exports = class
    constructor: (@tiles) ->

    getTile: (x, y) ->
        row = @tiles[y]
        if row then row[x] or null else null

    getSize: ->
        { x: @tiles.length, y: @tiles[0].length or 0 }

    toString: ->
        mappedRows = @tiles.map((row) -> row.map((card) -> if card? then card.toString() else '.').join('')).join '\n'

    getTowns: ->
        []