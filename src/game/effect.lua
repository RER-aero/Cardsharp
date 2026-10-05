local Effect = {}

function Effect.new(trigger, action)
    local effect = {
        trigger = trigger,
        action = action
    }

    return effect
end

function Effect.trigger(effect, context)
    effect.action(context)
end

function Effect.checkTriggers(items, context, trigger)
    for _, item in ipairs(items) do
        for _, effect in ipairs(item.effects) do
            if effect.trigger == trigger then
                Effect.trigger(effect, context)
            end
        end
    end
end

return Effect
