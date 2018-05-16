LandsCard = require './lands'

module.exports = class TownLandsCard extends LandsCard
    constructor: (pos) ->
        super pos
    
    toString: () -> 'T'