WorldBuilder = require './world/builder'

module.exports = class Game
    builder = new WorldBuilder {
        towns: 15
    }
    @world = builder.build()
    console.log(@world.toString())
