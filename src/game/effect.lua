local Effect = {}





function Effect.new(trigger, action)
    local effect = {
        trigger = trigger,
        action = action
    }

    return effect
end


function Effect.trigger(effect, playerHand, dealerHand)
 
        effect.action(playerHand, dealerHand)
end

function Effect.checkTriggers(suits, playerHand, dealerHand, trigger)
    for _, suit in ipairs(suits) do
        for _, effect in ipairs(suit.effects) do
            if effect.trigger == trigger then
            Effect.trigger(effect, playerHand, dealerHand)
            end
        end
    end
end



















return Effect