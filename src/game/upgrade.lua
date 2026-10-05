local Upgrade = {}
local Effect = require("src.game.effect")
function Upgrade.new(name, description, cost, trigger, effect, sprite)
    return {
        name = name,
        description = description,
        cost = cost,
        trigger = trigger,
        effect = effect,
        sprite = sprite
    }
end

function Upgrade.checkTriggers(upgrades, context, trigger)
    for _, upgrade in ipairs(upgrades) do
        if upgrade.trigger == trigger then
            Effect.trigger(upgrade.effect, context)
        end
    end
end

return Upgrade