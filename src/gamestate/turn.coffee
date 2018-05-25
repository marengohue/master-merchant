module.exports = class Turn
    constructor: (@player, @game) ->
        @whenDone = new Promise (resolve, _) =>
            @endTurn = resolve 