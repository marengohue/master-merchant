React = require 'react'

module.exports = class ItemCardComponent extends React.Component
    constructor: (props) ->
        super props

    applyCardColor: (styleObj) ->
        color = @props.item.getColor()
        Object.assign (if color? then { color } else { }), styleObj

    render: ->       
        <li className={'stacked-card item'}>
            <span className="card-title">{@props.item.getTitle()}</span>
            <figure className="image" style={@applyCardColor()}>{@props.item.getImage()}</figure>
            <span class="card-value">{@props.item.value} ☼</span>
            <p className="text">
                {@props.item.getText()}
            </p>
        </li>