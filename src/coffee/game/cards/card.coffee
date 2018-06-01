uuid = require 'uuid'

module.exports = class Card
    getColor: ->
        '#FFFFFF'

    getTitle: ->
        @constructor.name

    getText: ->
        @constructor.name

    getImage: ->
        @constructor.name[0].toUpperCase()

    constructor: ->
        @uid = uuid()