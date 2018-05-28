LandsCard = require './lands.coffee'

module.exports = class ForestLandsCard extends LandsCard   
    constructor: (@pos) ->
        super()
        

    toString: () ->
        '↟'