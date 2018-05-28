module.exports = class Turn
    constructor: (@game) ->
        @whenDone = new Promise (resolve, _) =>
            @endTurn = resolve 

    getNextState: ->
        throw new Error 'getNextState() is not implemented!'