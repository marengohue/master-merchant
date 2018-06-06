React = require 'react'
CardComponent = require './card.coffee'
FlippableComponent = require './flippable.coffee'

module.exports = class LandsCardComponent extends CardComponent
    applyCardColor: (styleObj) ->
        color = @props.card.getColor()
        Object.assign (if color? then { color } else { }), styleObj

    getPositionalStyle: ->
        top: @props.card.pos.y * 320 + 'px'
        left: @props.card.pos.x * 230 + 'px'

    getGlobalClasses: ->
        super.getGlobalClasses().concat 'absolute'

    getCardFront: ->
        <div className="card-front lands">
            <span className="card-title">{@props.card.getTitle()}</span>
            <figure className="image" style={@applyCardColor()}>{@props.card.getImage()}</figure>
            <p className="text">
                {@props.card.getText()}
            </p>
        </div>