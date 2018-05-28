Deck = require '../deck.coffee'
Card = require '../card.coffee'

module.exports = class CharacterCard extends Card
    constructor: ->
        super()
        @items = new Deck