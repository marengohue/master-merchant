uuid = require 'uuid'
EventEmitter = require 'events'

module.exports = class Card extends EventEmitter
    getColor: ->
        '#FFFFFF'

    flip: (faceup) ->
        newState = if faceup? then not faceup else not @isFacedown
        if @isFacedown isnt newState
            @isFacedown = newState
            @emit 'flipped', @isFacedown

    getTitle: ->
        @constructor.name

    getText: ->
        @constructor.name

    getImage: ->
        @constructor.name[0].toUpperCase()

    constructor: ->
        super()
        @uid = uuid()
        @isFacedown = false