LandsCard = require './lands.coffee'

module.exports = class RiverLandsCard extends LandsCard   
    constructor: (@pos) ->
        super()
        

    toString: () ->
        '≈'