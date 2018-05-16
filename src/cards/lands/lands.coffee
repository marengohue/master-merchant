Card = require '../card'

module.exports = class LandsCard extends Card   
    constructor: (@pos) ->
        super()
        

    toString: () ->
        '.'