React = require 'react'

World = require '../game/world/world.coffee'
TileCardComponent = require './tile-card.coffee'

module.exports = class WorldMapComponent extends React.Component
    render: ->
        <ul className="world-map">
            { @props.world.getFlatTiles().map (tileCard) -> <TileCardComponent key={tileCard.uid} tile={tileCard}/> }
        </ul>