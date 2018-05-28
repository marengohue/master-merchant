ItemCard = require '../cards/items/item.coffee' 
ItemRoughGem = require '../cards/items/gems/rough-gem.coffee'
ItemCutGem = require '../cards/items/gems/cut-gem.coffee'
ItemBasicFood = require '../cards/items/food/basic-food.coffee'
ItemBasicDrink = require '../cards/items/drink/basic-drink.coffee'
ItemMaterial = require '../cards/items/materials/material.coffee'
registry = 
    encounters: {}
    items: []

registry.encounters[require '../cards/lands/town.coffee'] = [
    require '../cards/encounters/town/tavern-brawl.coffee'
    require '../cards/encounters/town/friend-in-need.coffee'
]

registry.items = [
    () -> new ItemBasicFood 'Plump Helmet', 3
    () -> new ItemBasicDrink 'Dwarven Ale', 3

    () -> new ItemMaterial 'Animal Skin', 5
    () -> new ItemMaterial 'Oak Wood', 3
    () -> new ItemMaterial 'Ash Wood', 3

    () -> new ItemRoughGem 'Small Rough Diamond', 100
    () -> new ItemRoughGem 'Small Rough Ruby', 25
    
    () -> new ItemCutGem 'Small Cut Diamond', 125
    () -> new ItemCutGem 'Small Cut Ruby', 50
]

module.exports = registry