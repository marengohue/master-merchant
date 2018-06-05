React = require 'react'
FlippableComponent = require './flippable.coffee'

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
        
        <li className="card-container" style={style}>
            <FlippableComponent
                flipped={@props.card.isFacedown}
                front={
                    <div className="card lands">
                        <span className="card-title">{@props.card.getTitle()}</span>
                        <figure className="image" style={@applyCardColor()}>{@props.card.getImage()}</figure>
                        <p className="text">
                            {@props.card.getText()}
                        </p>
                    </div>
                }
                back={
                    <div className="card lands">
                        <figure className="image">☼</figure>
                    </div>
                }
            />
        </li>