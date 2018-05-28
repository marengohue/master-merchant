EncounterCard = require '../encounter'

module.exports = class TavernBrawlEncounterCard extends EncounterCard
    toString: () ->
        't'
    
    resolve: () ->
        Promise.resolve null