Deck = require '../deck'
Card = require '../card'

module.exports = class CharacterCard extends Card
    constructor: ->
        super()
        @items = new Deck