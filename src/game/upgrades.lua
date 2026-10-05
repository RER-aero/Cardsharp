local Upgrades = {}

local Upgrade = require("src.game.upgrade")
local Effect = require("src.game.effect")

Upgrades.allUpgrades = {}

local chip = Upgrade.new(
    "Red Chip",
    "Gain 1-3 extra chips at the end of each round.",
    50,
    "round_over",
    Effect.new(
        "round_over",
        function(context)
            context.game.addChips(love.math.random(1, 3))
        end
    )
)

table.insert(Upgrades.allUpgrades, chip)

function Upgrades.randomPick()
    return Upgrades.allUpgrades[love.math.random(1, #Upgrades.allUpgrades)]
end

return Upgrades