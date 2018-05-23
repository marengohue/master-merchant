Card = require '../card'
Colors = require 'colors'

module.exports = class ItemCard extends Card
    constructor: (@name, @value) ->
        super()
        
    toString: () ->
        Colors.magenta 'i'