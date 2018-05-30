LandsCard = require './lands.coffee'

module.exports = class RiverLandsCard extends LandsCard   
    constructor: (@pos) ->
        super()
        
    getColor: () ->
        '#3d49d3'

    toString: () ->
        '≈'