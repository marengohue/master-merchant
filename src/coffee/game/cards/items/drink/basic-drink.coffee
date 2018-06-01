ItemDrink = require './drink.coffee'

module.exports = class ItemBasicDrink extends ItemDrink
    getColor: ->
        'gold'

    getTitle: ->
        'Dwarven Ale'

    getImage: ->
        '%'

    getText: ->
        'Urist has been tired of drinking the same old booze lately...'