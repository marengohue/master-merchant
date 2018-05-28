EncounterCard = require '../encounter.coffee'

module.exports = class FriendInNeedEncounterCard extends EncounterCard
    toString: () ->
        'f'

    resolve: () ->
        Promise.resolve null