React = require 'react'

module.exports = class FlippableComponent extends React.Component
    render: ->
        <div className={"flippable" + if @props.flipped then " flipped" else ""}>
            <div className="flippable-content">
                <div className="flippable-front">
                    {@props.front}
                </div>
                <div className="flippable-back">
                    {@props.back}
                </div>
            </div>
        </div>