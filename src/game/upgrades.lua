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
    ),
    1
)
Upgrades.allUpgrades.red_chip = chip

function Upgrades.randomPick()
    local upgrades = {}

    for _, upgrade in pairs(Upgrades.allUpgrades) do
        table.insert(upgrades, upgrade)
    end

    return upgrades[love.math.random(1, #upgrades)]
end

return Upgrades
