React = require 'react'

World = require '../game/world/world.coffee'
TileCardComponent = require './tile-card.coffee'

module.exports = class WorldMapComponent extends React.Component
    render: ->
        style = 
            height: @props.world.getSize().y * 117 + 'px'
            
        <ul className="world-map" style={style}>
            { @props.world.getFlatTiles().map (tileCard) -> <TileCardComponent key={tileCard.uid} tile={tileCard}/> }
        </ul>