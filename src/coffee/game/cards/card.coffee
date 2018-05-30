uuid = require 'uuid'

module.exports = class Card
    getColor: ->
        '#FFFFFF'

    constructor: ->
        @uid = uuid()