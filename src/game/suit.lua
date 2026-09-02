local Suit = {}



function Suit.new(name, symbol, description)
    local suit = {
        id = name:lower(),
        name = name,
        symbol = symbol,
        description = description,
        effects = {}
    }

    return suit
end

function Suit.addEffect(suit, effect)
        table.insert(suit.effects, effect)

        return suit
end



return Suit