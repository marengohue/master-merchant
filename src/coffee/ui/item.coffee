React = require 'react'
CardComponent = require './card.coffee'

module.exports = class ItemCardComponent extends CardComponent
    getGlobalClasses: ->
        super.getGlobalClasses().concat 'stacked'

    getCardFront: ->       
        <div className="card-front item">
            <span className="card-title">{@props.card.getTitle()}</span>
            <figure className="image" style={@applyCardColor()}>{@props.card.getImage()}</figure>
            <span className="card-value">{@props.card.value} ☼</span>
            <p className="text">
                {@props.card.getText()}
            </p>
        </div>