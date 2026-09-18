local Modifier = {}

function Modifier.new(trigger, action)
    local modifier = {
        trigger = trigger,
        action = action
    }

    return modifier
end

function Modifier.apply(modifier, card, value)
    return modifier.action(card, value)
end

function Modifier.checkModifiers(suits, card, value, trigger)
    if not suits then
        return value
    end

    for _, suit in ipairs(suits) do
        if suit.modifiers then
            for _, modifier in ipairs(suit.modifiers) do
                if modifier.trigger == trigger then
                    value = Modifier.apply(modifier, card, value)
                end
            end
        end
    end

    return value
end

return Modifier