React = require 'react'
FlippableComponent = require './flippable.coffee'

module.exports = class TileCardComponent extends React.Component
    constructor: (props) ->
        super props

    applyCardColor: (styleObj) ->
        color = @props.card.getColor()
        Object.assign (if color? then { color } else { }), styleObj
    
    getCardClassName: ->
        ''

    render: ->
        style =         
            top: @props.card.pos.y * 320 + 'px'
            left: @props.card.pos.x * 230 + 'px'
        
        <li className={@getCardClassName() + ' card'} style={style}>
            <FlippableComponent
                flipped=false
                front={
                    <div>
                        <span className="card-title">{@props.card.constructor.name}</span>
                        <figure className="image" style={@applyCardColor()}>{@props.card.toString()}</figure>
                        <p className="text">
                            {@props.card.constructor.name}
                        </p>
                    </div>
                }
                back={
                    <p>☼</p>
                }
            />
        </li>