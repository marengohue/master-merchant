React = require 'react'
FlippableComponent = require './flippable.coffee'

module.exports = class LandsCardComponent extends React.Component
    constructor: (props) ->
        super props
        @state =
            flipped: @props.card.isFacedown

    applyCardColor: (styleObj) ->
        color = @props.card.getColor()
        Object.assign (if color? then { color } else { }), styleObj

    flipCard: ->
        @setState (old) ->
            flipped: !old.flipped

    render: ->
        style =         
            top: @props.card.pos.y * 320 + 'px'
            left: @props.card.pos.x * 230 + 'px'
        
        <li className="card-container" style={style} onClick={@flipCard.bind @}>
            <FlippableComponent
                flipped={@state.flipped}
                front={
                    <div className="card-front lands">
                        <span className="card-title">{@props.card.getTitle()}</span>
                        <figure className="image" style={@applyCardColor()}>{@props.card.getImage()}</figure>
                        <p className="text">
                            {@props.card.getText()}
                        </p>
                    </div>
                }
                back={
                    <div className="card-back">
                        <figure className="image">☼</figure>
                    </div>
                }
            />
        </li>