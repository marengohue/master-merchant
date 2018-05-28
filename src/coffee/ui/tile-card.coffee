React = require 'react'

module.exports = class TileCardComponent extends React.Component
    render: ->
        style = 
            top: @props.tile.pos.y * 117 + 'px'
            left: @props.tile.pos.x * 85 + 'px'
        
        <li className="tile-card" style={style}>
            <span class="header">{@props.tile.constructor.name}</span>
            <figure class="image">{@props.tile.toString()}</figure>
            <p class="text">
                {@props.tile.constructor}
            </p>
        </li>