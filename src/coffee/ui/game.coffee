React = require 'react'
WorldMapComponent = require './map.coffee'

module.exports = class GameComponent extends React.Component
    render: ->
        (<div>
            <p>Ok, the turn is {@props.game.turnCount}</p>
            <WorldMapComponent world={@props.game.world}/>
        </div>)