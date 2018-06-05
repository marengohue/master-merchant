LandsCard = require './lands.coffee'

module.exports = class TownLandsCard extends LandsCard
    constructor: (pos) ->
        super pos
        @townTitle = 'Town'
        @isFacedown = false
    
    getImage: ->
        '⟰'

    getTitle: ->
        @townTitle

    getText: ->
        'Town'

    toString: ->
        '⟰'