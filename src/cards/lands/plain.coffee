LandsCard = require './lands'
Colors = require 'colors'

module.exports = class PlainLandsCard extends LandsCard   
    constructor: (@pos) ->
        super()
        

    toString: () ->
        Colors.yellow '.'