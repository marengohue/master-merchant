LandsCard = require './lands.coffee'

module.exports = class TownLandsCard extends LandsCard
    constructor: (pos) ->
        super pos
        @townTitle = 'Town'
    
    getImage: ->
        '⟰'

    getTitle: ->
        @townTitle

    getText: ->
        'Town'

    toString: ->
        '⟰'