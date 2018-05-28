Card = require '../card.coffee'

module.exports = class ItemCard extends Card
    constructor: (@name, @value) ->
        super()
        
    toString: () ->
        'i'