React = require 'react'
FlippableComponent = require './flippable.coffee'

module.exports = class CardComponent extends React.Component
    constructor: (props) ->
        super props
        @state =
            flipped: @props.card.isFacedown

    handleCardFlip: (isFlipped) ->
        @setState (old) ->
            flipped: isFlipped

    componentDidMount: ->
        @boundFlipHandler = @handleCardFlip.bind @
        @props.card.on 'flipped', @boundFlipHandler

    componentWillUnmount: ->
        @props.card.off 'flipped', @boundFlipHandler

    handleCardClick: ->
        if @props.cardClickedHandler?
            @props.cardClickedHandler @

    applyCardColor: (styleObj) ->
        color = @props.card.getColor()
        Object.assign (if color? then { color } else { }), styleObj

    getPositionalStyle: -> 
        {}

    getGlobalClasses: ->
        classes = [ 'card-container' ]
        if @props.highlighted
            classes.push 'highlighted'
        return classes

    getCardFront: ->
        <div className="card-front generic">This is a generic card front</div>

    render: ->
        <li className={((@getGlobalClasses() or []).join ' ')} style={@getPositionalStyle()} onClick={@handleCardClick.bind @}>
            <FlippableComponent
                flipped={@state.flipped}
                front={
                    @getCardFront()
                }
                back={
                    <div className="card-back">
                        <figure className="image">☼</figure>
                    </div>
                }
            />
        </li>