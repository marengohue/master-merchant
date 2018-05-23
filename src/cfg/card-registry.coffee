ItemCard = require '../cards/items/item' 
ItemRoughGem = require '../cards/items/gems/rough-gem'
ItemCutGem = require '../cards/items/gems/cut-gem'
ItemBasicFood = require '../cards/items/food/basic-food'
ItemBasicDrink = require '../cards/items/drink/basic-drink'
ItemMaterial = require '../cards/items/materials/material'
registry = 
    encounters: {}
    items: []

registry.encounters[require '../cards/lands/town'] = [
    require '../cards/encounters/town/tavern-brawl'
    require '../cards/encounters/town/friend-in-need'
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