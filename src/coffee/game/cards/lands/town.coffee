LandsCard = require './lands.coffee'

module.exports = class TownLandsCard extends LandsCard
    constructor: (pos) ->
        super pos
    
    toString: ->
        'T'