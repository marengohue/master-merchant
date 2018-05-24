Deck = require './cards/deck'

module.exports = class Character
    constructor: ->
        @items = new Deck