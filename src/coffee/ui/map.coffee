React = require 'react'

World = require '../game/world/world.coffee'
LandsCardComponent = require './lands.coffee'

module.exports = class WorldMapComponent extends React.Component
    render: ->
        style = 
            height: @props.world.getSize().y * 117 + 300 + 'px'
        
        <ul className="world-map" style={style}>
            {
                @props.world.getFlatTiles().map (tileCard) =>
                    <LandsCardComponent
                        highlighted={(@props.highlighted or []).indexOf(tileCard.uid) isnt -1}
                        key={tileCard.uid}
                        card={tileCard}
                        cardClickedHandler={@props.cardClickedHandler}
                    />
            }
        </ul>