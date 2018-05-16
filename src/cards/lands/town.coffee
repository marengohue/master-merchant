LandsCard = require './lands'
Colors = require 'colors'

module.exports = class TownLandsCard extends LandsCard
    constructor: (pos) ->
        super pos
    
    toString: ->
        Colors.white Colors.bold 'T'