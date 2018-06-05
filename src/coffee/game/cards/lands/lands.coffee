Card = require '../card.coffee'

module.exports = class LandsCard extends Card   
    constructor: (@pos) ->
        super()
        @isFacedown = true
        
    getColor: () ->
        null

    getText: ->
        'Wilderness'

    toString: () ->
        'x'