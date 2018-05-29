React = require 'react'

module.exports = class CardFocuser extends React.Component
    constructor: (props) ->
        console.log props.dimmed
        super props

    render: ->
        document.body.classList[if @props.dimmed then 'add' else 'remove'] 'dimmed'
        <div className="dimmer-wrapper">
            <div className={if @props.dimmed then 'dimmer dimmed' else 'dimmer'}></div>
            <div className="dimmerContents">
                {@props.children}
            </div>
        </div>