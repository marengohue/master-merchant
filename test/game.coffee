chai = require 'chai'

Game = require '../src/game'
WorldBuilder = require '../src/world/builder'

describe 'Game', ->
    it 'Should use given builder', ->
        wrongBuilder = new WorldBuilder towns: 15, sizeX: 3, sizeY: 3
        chai.expect(-> new Game worldBuilder).to.throw()

    it 'Should have a deck for each terrain type in the world', ->
        