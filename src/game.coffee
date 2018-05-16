WorldBuilder = require './world/builder'

module.exports = class Game
    constructor: (worldSettings) ->
        worldBuilder = new WorldBuilder worldSettings
        @world = worldBuilder.build()
