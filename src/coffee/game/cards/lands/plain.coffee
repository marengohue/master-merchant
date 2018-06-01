LandsCard = require './lands.coffee'

module.exports = class PlainLandsCard extends LandsCard   
    constructor: (@pos) ->
        super()
        
    getColor: ->
        '#87db72'

    getImage: ->
        '⥭'

    getTitle: ->
        'Plains'
        
    toString: ->
        '⥭'