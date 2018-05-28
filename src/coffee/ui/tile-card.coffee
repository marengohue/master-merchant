React = require 'react'

module.exports = class TileCardComponent extends React.Component
    render: ->
        style = 
            top: @props.tile.pos.y * 60 + 'px'
            left: @props.tile.pos.x * 60 + 'px'
        
        <li className="tile-card" style={style}>{@props.tile.constructor.name[0]}</li>