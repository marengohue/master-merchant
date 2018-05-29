React = require 'react'

module.exports = class InfoComponent extends React.Component
    render: ->
        <header>
            <a href="index.html">
                <h1>☼ Master Merchant ☼</h1>
            </a>
            <span>See the <a href="https://github.com/marengohue/master-merchant/blob/master/RULES.md" target="_blank">RULES</a> of the game.</span>
            <p>Ok, the turn is {@props.game.turnCount}</p>
        </header>