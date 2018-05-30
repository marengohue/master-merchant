React = require 'react'

module.exports = class ItemCardComponent extends React.Component
    constructor: (props) ->
        super props

    applyCardColor: (styleObj) ->
        color = @props.item.getColor()
        Object.assign (if color? then { color } else { }), styleObj

    render: ->       
        <li className={'stacked-card item'}>
            <span className="card-title">{@props.item.constructor.name}</span>
            <figure className="image" style={@applyCardColor()}>{@props.item.toString()}</figure>
            <p className="text">
                {@props.item.constructor.name}
            </p>
        </li>