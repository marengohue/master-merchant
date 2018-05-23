TownLandsCard = 

registry = 
    encounters: {}

registry.encounters[require '../cards/lands/town'] = [
    require '../cards/encounters/town/tavern-brawl'
    require '../cards/encounters/town/friend-in-need'
]

module.exports = registry