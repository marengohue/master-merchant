React = require 'react'
WorldMapComponent = require './map.coffee'
InfoComponent = require './info.coffee'
CardFocuserComponent = require './card-focuser.coffee'

module.exports = class GameComponent extends React.Component
    setFocusCards: (cardComponent) ->
        @setState (old) ->
            focusCard: cardComponent

    render: ->
        <main className="game">
            <CardFocuserComponent/>
            <InfoComponent game={@props.game}/>
            <WorldMapComponent world={@props.game.world}/>
        </main>