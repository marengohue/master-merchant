LandsCard = require './lands.coffee'

module.exports = class PlainLandsCard extends LandsCard   
    constructor: (@pos) ->
        super()
        
    toString: () ->
        '.'