EncounterCard = require '../encounter'
Colors = require 'colors'

module.exports = class TavernBrawlEncounterCard extends EncounterCard
    toString: () ->
        Colors.red 't'
    
    resolve: () ->
        Promise.resolve null