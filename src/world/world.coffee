LandsCard = require '../cards/lands/lands'

module.exports = class
    constructor: (@tiles) ->

    getTile: (x, y) ->
        row = @tiles[y]
        if row then row[x] or null else null

    getSize: ->
        { x: @tiles.length, y: @tiles[0].length or 0 }