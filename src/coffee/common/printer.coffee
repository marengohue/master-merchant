module.exports = class Printer
    @printWorldTiles: (tiles) ->
        tiles.map((row) -> row.map((card) -> if card? then card.toString() else ' ').join('')).join '\n'