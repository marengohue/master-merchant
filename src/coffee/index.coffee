ReactDOM = require 'react-dom'
React = require 'react'
GameComponent = require './ui/game.coffee'

document.addEventListener 'DOMContentLoaded', ->
    ReactDOM.render(<GameComponent/>, document.getElementById('game-root'))