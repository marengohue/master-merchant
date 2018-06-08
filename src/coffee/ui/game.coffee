React = require 'react'
WorldMapComponent = require './map.coffee'
InfoComponent = require './info.coffee'
DeckComponent = require './deck.coffee'

TurnMovement = require '../game/gamestate/move.coffee'
TurnTrade = require '../game/gamestate/trade.coffee'
TurnSimulation = require '../game/gamestate/world-sim.coffee'

module.exports = class GameComponent extends React.Component
    constructor: (props) ->
        super props
        @state = focusCard: null

    setFocusCards: (cardComponent) ->
        @setState (old) ->
            focusCard: cardComponent

    getCardsToHighlight: ->
        if @props.game.state instanceof TurnMovement
            return @props.game.state
                .getAvailableTilesToMove()
                .map (pos) => @props.game.world.getTile(pos).uid

    onRightClick: (event) ->
        event.preventDefault()

    componentDidMount: ->
        @props.game.on 'stateChange', (newState) =>
            @setState (oldState) ->
                state: newState

    cardClickedHandler: (cardComponent) ->
        if @props.game.state instanceof TurnMovement
            try
                @props.game.state.moveTo cardComponent.props.card.pos
            catch _
            
    render: ->
        <main className="game" onContextMenu={@onRightClick}>
            <InfoComponent game={@props.game}/>
            <WorldMapComponent cardClickedHandler={@cardClickedHandler.bind @} highlighted={@getCardsToHighlight()} world={@props.game.world}/>
            <DeckComponent deck={@props.game.players[0].wagon}/>
        </main>