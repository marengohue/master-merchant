Card = require '../card.coffee'

module.exports = class LandsCard extends Card   
    constructor: (@pos) ->
        super()
        

    toString: () ->
        'x'