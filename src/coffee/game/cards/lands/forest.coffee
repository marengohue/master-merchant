LandsCard = require './lands.coffee'

module.exports = class ForestLandsCard extends LandsCard   
    constructor: (@pos) ->
        super()

    getColor: () ->
        '#0e725d'        

    toString: () ->
        '↟'