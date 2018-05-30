React = require 'react'
WorldMapComponent = require './map.coffee'
InfoComponent = require './info.coffee'
DeckComponent = require './deck.coffee'

module.exports = class GameComponent extends React.Component
    constructor: (props) ->
        super props
        @state = focusCard: null

    setFocusCards: (cardComponent) ->
        @setState (old) ->
            focusCard: cardComponent

    onRightClick: (event) ->
        event.preventDefault()

    render: ->
        <main className="game" onContextMenu={@onRightClick}>
            <InfoComponent game={@props.game}/>
            <WorldMapComponent world={@props.game.world}/>
            <DeckComponent deck={@props.game.players[0].wagon}/>
        </main>