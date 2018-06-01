ItemFood = require './food.coffee'

module.exports = class ItemBasicFood extends ItemFood
    getColor: ->
        '#bb11aa'

    getTitle: ->
        'Plump Helmets'

    getImage: ->
        '♠'
        #♣

    getText: ->
        'Urist likes plump helmets for their rounded tops...'