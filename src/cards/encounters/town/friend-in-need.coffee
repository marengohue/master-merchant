EncounterCard = require '../encounter'
Colors = require 'colors'

module.exports = class FriendInNeedEncounterCard extends EncounterCard
    toString: () ->
        Colors.red 'f'

    resolve: () ->
        Promise.resolve null