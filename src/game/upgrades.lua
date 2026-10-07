local Upgrades = {}

local Upgrade = require("src.game.upgrade")
local Effect = require("src.game.effect")

Upgrades.allUpgrades = {}
function Upgrades.addUpgrade(id, upgrade)
    Upgrades.allUpgrades[id] = upgrade
    return upgrade
end

function ug()
    Upgrades.addUpgrade("red_chip", Upgrade.new( --Red Chip
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
    ))
    Upgrades.addUpgrade("blue_chip", Upgrade.new( --Blue Chip
        "Blue Chip",
        "Gain 2 chips for each card below 52 in your deck.",
        0,
        "player_win",
        Effect.new(
            "player_win",
            function(context)
                context.game.addChips(
                    2 * (52 - #context.game.CurrentDeck)
                )
            end
        ),
        2
    ))
     Upgrades.addUpgrade("pink_chip", Upgrade.new( --Pink Chip
        "Pink Chip",
        "1/10 chance to double chips gained when getting a blackjack.",
        0,
        "blackjack",
        Effect.new(
            "blackjack",
            function(context)
                if love.math.random(1, 10) == 1 then
                    context.game.addChips(15) 
                end
            end
        ),
        3
    ))
    Upgrades.addUpgrade("purple_chip", Upgrade.new( --Purple Chip
        "Purple Chip",
        "Gain 1 extra chip for each card in your hand at the end of a winning round.",
        4,
        "player_win",
        Effect.new(
            "player_win",
            function(context)
                context.game.addChips(#context.playerHand)
            end
        ),
        3
    ))
    Upgrades.addUpgrade("teal_chip", Upgrade.new( --Teal Chip
        "Teal Chip",
        "After continuing instead of cashing out, gain 1-3 extra chips.",
        4,
        "continue",
        Effect.new(
            "continue",
            function(context)
                context.game.addChips(love.math.random(1, 3))
            end
        ),
        3
    ))
    Upgrades.addUpgrade("green_chip", Upgrade.new( --Green Chip
        "Green Chip",
        "If initial hand is purely face cards gain 5 chips",
        4,
        "round_start",
        Effect.new(
            "round_start",
            function(context)
                if #context.playerHand == 2 and context.playerHand[1].rank >= 11 and context.playerHand[2].rank >= 11 then
                    context.game.addChips(5)
                end
            end
        ),
        3
    ))
end

function Upgrades.randomPick()
    local upgrades = {}

    for _, upgrade in pairs(Upgrades.allUpgrades) do
        table.insert(upgrades, upgrade)
    end

    return upgrades[love.math.random(1, #upgrades)]
end

ug()
return Upgrades
