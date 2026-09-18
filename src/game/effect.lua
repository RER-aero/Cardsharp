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

function Effect.checkTriggers(suits, context, trigger)
    for _, suit in ipairs(suits) do
        for _, effect in ipairs(suit.effects) do
            if effect.trigger == trigger then
                Effect.trigger(effect, context)
            end
        end
    end
end



















return Effect