React = require 'react'

Game = require '../game/game.coffee'
WorldBuilder = require '../game/world/builder.coffee'

module.exports = class GameComponent extends React.Component
    constructor: (props) ->
        super props
        @game = new Game (new WorldBuilder), null, 1

    render: ->
        <p> Ok, the game is setup </p>