EncounterCard = require '../encounter'
Colors = require 'colors'

module.exports = class FriendInNeedEncounterCard extends EncounterCard
    toString: () ->
        Colors.red 'f'