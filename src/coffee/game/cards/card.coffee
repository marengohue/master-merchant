uuid = require 'uuid'

module.exports = class Card
    constructor: ->
        @uid = uuid()