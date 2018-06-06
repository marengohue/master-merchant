Deck = require './cards/deck.coffee'
Character = require './cards/characters/character.coffee'
ItemBasicDrink = require './cards/items/drink/basic-drink.coffee'
ItemBasicFood = require './cards/items/food/basic-food.coffee'

module.exports = class Player
    constructor: (@pos, @name) ->
        @name ?= 'marengo'
        @wagon = new Deck
        @playerCharacter = new Character
        @party = [ @playerCharacter ]
        for foods in [1..10] then @wagon.putOnTop (new ItemBasicFood 'Plump Helmet', 3)
        for drinks in [1..10] then @wagon.putOnTop (new ItemBasicDrink 'Dwarven Ale', 3)