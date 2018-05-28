ReactDOM = require 'react-dom'
React = require 'react'

GameComponent = require './ui/game.coffee'

Game = require './game/game.coffee'
WorldBuilder = require './game/world/builder.coffee'

document.addEventListener 'DOMContentLoaded', ->
    game = new Game (new WorldBuilder sizeX: 15, sizeY: 10), null, 1
    ReactDOM.render(<GameComponent game={game}/>, document.getElementById('game-root'))