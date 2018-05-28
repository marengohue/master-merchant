Deck = require './cards/deck'
Character = require './cards/characters/character'
ItemBasicDrink = require './cards/items/drink/basic-drink'
ItemBasicFood = require './cards/items/food/basic-food'

module.exports = class Player
    constructor: (@pos) ->
        @wagon = new Deck
        @playerCharacter = new Character
        @party = [ @playerCharacter ]
        for foods in [1..10] then @wagon.putOnTop (new ItemBasicFood 'Plump Helmet', 3)
        for drinks in [1..10] then @wagon.putOnTop (new ItemBasicDrink 'Dwarven Ale', 3)