React = require 'react'
TurnMovement = require '../game/gamestate/move.coffee'
TurnTrade = require '../game/gamestate/trade.coffee'
TurnSimulation = require '../game/gamestate/world-sim.coffee'

module.exports = class InfoComponent extends React.Component
    getTurnDescription: ->
        if @props.game.state instanceof TurnMovement
            <div>
                <p>{@props.game.state.player.name + '\'s turn'}</p>
                <p>Choose where to move to (Eligible lands are highlighted)</p>
            </div>

    render: ->
        <header>
            <a href="index.html">
                <h1>☼ Master Merchant ☼</h1>
            </a>
            <span>See the <a href="https://github.com/marengohue/master-merchant/blob/master/RULES.md" target="_blank">RULES</a> of the game.</span>
            <p>Ok, the turn is {@props.game.turnCount}</p>
            {@getTurnDescription()}
        </header>