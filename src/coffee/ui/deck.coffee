React = require 'react'
ItemCardComponent = require './item.coffee'

_ = require 'underscore'

module.exports = class ItemDeckComponent extends React.Component
    constructor: (params) ->
        super params
        @state = params.deck
    
    render: ->
        groupings = _.groupBy @state.stack, (card) -> card.constructor
        valueGroups = _.values groupings

        <div className="deck">
            {
                valueGroups.map (group, groupIndex) ->
                    <div className="card-group" key={groupIndex}>
                        {
                            group.map (card, index) ->
                                <ItemCardComponent key={card.uid} card={card} />
                        }
                    </div>
            }
        </div>