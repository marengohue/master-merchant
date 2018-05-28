EncounterCard = require '../encounter.coffee'

module.exports = class TavernBrawlEncounterCard extends EncounterCard
    toString: () ->
        't'
    
    resolve: () ->
        Promise.resolve null