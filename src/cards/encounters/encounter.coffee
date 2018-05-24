Card = require '../card'

module.exports = class EncounterCard extends Card
    toString: () ->
        Colors.red '?'

    resolve: () ->
        Promise.resolve null