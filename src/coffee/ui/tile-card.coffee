React = require 'react'
module.exports = class TileCardComponent extends React.Component
    constructor: (props) ->
        super props
        @state = zoomed: false

    handleZoom: (e) ->
        e.preventDefault()
        @setState (prev) ->
            zoomed: !prev.zoomed;

    zoomCard: (val) ->
        @setState (prev) ->
            zoomed: val;


    render: ->
        style = 
            if not @state.zoomed
                top: @props.tile.pos.y * 320 + 'px'
                left: @props.tile.pos.x * 230 + 'px'

        <li className={"tile-card" + (if @state.zoomed then " zoomed" else "")} style={style} onContextMenu={this.handleZoom.bind(@)}>
            <span className="header">{@props.tile.constructor.name}</span>
            <figure className="image">{@props.tile.toString()}</figure>
            <p className="text">
                {@props.tile.constructor.name}
            </p>
        </li>