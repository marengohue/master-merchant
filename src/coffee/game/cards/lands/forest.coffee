LandsCard = require './lands.coffee'
Colors = require 'colors'

module.exports = class ForestLandsCard extends LandsCard   
    constructor: (@pos) ->
        super()
        

    toString: () ->
        Colors.green '↟'