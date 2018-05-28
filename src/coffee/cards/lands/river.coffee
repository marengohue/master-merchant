LandsCard = require './lands.coffee'
Colors = require 'colors'

module.exports = class RiverLandsCard extends LandsCard   
    constructor: (@pos) ->
        super()
        

    toString: () ->
        Colors.blue '≈'