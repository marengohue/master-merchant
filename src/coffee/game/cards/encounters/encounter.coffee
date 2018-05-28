Card = require '../card.coffee'

module.exports = class EncounterCard extends Card
    toString: () ->
        '?'

    resolve: () ->
        Promise.resolve null