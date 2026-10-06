local Upgrade = {}

local Effect = require("src.game.effect")
local anim8 = require("libraries.anim8")

local chipSheet = love.graphics.newImage("assets/upgrades/chip_spritesheet.png")

local chipGrid = anim8.newGrid(
    32,
    32,
    chipSheet:getWidth(),
    chipSheet:getHeight()
)

function Upgrade.new(name, description, cost, trigger, effect, SpriteIndex)
    local chipAnimation = anim8.newAnimation(
        chipGrid(SpriteIndex, "1-11"),
        0.08
    )


    chipAnimation:pause()

    return {
        name = name,
        description = description,
        cost = cost,
        trigger = trigger,
        effect = effect,
        animation = chipAnimation,
        spriteIndex = SpriteIndex,
        animating = false
    }
end

function Upgrade.checkTriggers(upgrades, context, trigger)
    for _, upgrade in ipairs(upgrades) do
        if upgrade.trigger == trigger then
            upgrade.animation:gotoFrame(1)
            upgrade.animation:resume()
            upgrade.animating = true

            print("UPGRADE TRIGGERED:", upgrade.name)

            Effect.trigger(upgrade.effect, context)
        end
    end
end

function Upgrade.update(upgrades, dt)
    for _, upgrade in ipairs(upgrades) do
        if upgrade.animating then
            upgrade.animation:update(dt)

            if upgrade.animation.position >= #upgrade.animation.frames then
                upgrade.animation:pause()
                upgrade.animation:gotoFrame(1)
                upgrade.animating = false
            end
        end
    end
end

function Upgrade.draw(upgrades, x, y)
    for i, upgrade in ipairs(upgrades) do
        upgrade.animation:draw(chipSheet, x , y+ (i - 1) * 25,0,3,3)
    end
end

return Upgrade