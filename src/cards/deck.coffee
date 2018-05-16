Card = require './card'

module.exports = class Deck
    constructor: (@stack = []) ->

    getTop: (count) ->
        if count?
            newStack = for card in [1..count] then @stack.pop()
            new Deck(newStack)
        else
            @stack.pop()

    putOnTop: (stackable) ->
        throw new Error unless stackable? and stackable instanceof Card or stackable instanceof Deck
        if stackable instanceof Deck
            @stack = @stack.concat stackable.stack
        else
            @stack.push stackable