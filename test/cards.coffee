chai = require 'chai'

Deck = require '../src/cards/deck'
Card = require '../src/cards/card'

describe 'Deck', ->
    deck = new Deck

    it 'Should be an object', ->
        chai.expect(Array.isArray deck).to.be.false
        chai.expect(typeof deck).to.equal 'object'

    describe '.putOnTop', ->
        it 'Should be a function', ->
            chai.expect(typeof deck.putOnTop).to.equal 'function'

        it 'Should throw when called with no argument', ->
            chai.expect(-> deck.putOnTop(new Card)).to.not.throw()
            chai.expect(-> deck.putOnTop()).to.throw()

        it 'Should only accept cards and decks as an argument', ->
            chai.expect(-> deck.putOnTop([new Card, new Card])).to.throw()
            chai.expect(-> deck.putOnTop(1)).to.throw()

        it 'Should merge decks when called with a deck argument', ->
            deck1 = new Deck
            card11 = new Card
            card12 = new Card

            deck2 = new Deck
            card21 = new Card
            card22 = new Card

            deck1.putOnTop card11
            deck1.putOnTop card12
            deck2.putOnTop card21
            deck2.putOnTop card22

            deck1.putOnTop(deck2)
            newDeck = deck1.getTop(3)
            
            chai.expect(deck1.stack).to.deep.equal [card11]
            chai.expect(newDeck.stack).to.deep.equal [card12, card21, card22]

    describe '.getTop', ->        
        it 'Should be a function', ->
            chai.expect(typeof deck.getTop).to.equal 'function'

        it 'Should return a single card obj when called with no args', ->
            result = deck.getTop()
            chai.expect(Array.isArray result).to.be.false
            chai.expect(typeof result).to.equal 'object'
            chai.expect(result instanceof Card).to.be.true

        it 'Should have a stack structure', ->
            deck = new Deck
            card1 = new Card
            card2 = new Card
            deck.putOnTop card1
            deck.putOnTop card2
            chai.expect(deck.getTop()).to.equal card2
            chai.expect(deck.getTop()).to.equal card1

        it 'Should yield you a stack of cards when using with a count argument', ->
            deck = new Deck
            card1 = new Card
            card2 = new Card
            card3 = new Card
            card4 = new Card
            deck.putOnTop new Deck [card1, card2, card3, card4]
            newDeck = deck.getTop(3)
            chai.expect(newDeck instanceof Deck).to.be.true
            
            chai.expect(newDeck.stack).to.deep.equal [ card2, card3, card4 ]
            chai.expect(deck.stack).to.deep.equal [ card1 ]