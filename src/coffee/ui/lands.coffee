React = require 'react'

module.exports = class LandsCardComponent extends React.Component
    constructor: (props) ->
        super props

    applyCardColor: (styleObj) ->
        color = @props.card.getColor()
        Object.assign (if color? then { color } else { }), styleObj

    render: ->
        style =         
            top: @props.card.pos.y * 320 + 'px'
            left: @props.card.pos.x * 230 + 'px'
        
        <li className={'lands card'} style={style}>
            <span className="card-title">{@props.card.constructor.name}</span>
            <figure className="image" style={@applyCardColor()}>{@props.card.toString()}</figure>
            <p className="text">
                {@props.card.constructor.name}
            </p>
        </li>