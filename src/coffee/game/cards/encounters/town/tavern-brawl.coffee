EncounterCard = require '../encounter.coffee'
Colors = require 'colors'

module.exports = class TavernBrawlEncounterCard extends EncounterCard
    toString: () ->
        Colors.red 't'
    
    resolve: () ->
        Promise.resolve null