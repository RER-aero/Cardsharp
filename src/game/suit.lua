local Suit = {}


function Suit.new(name, symbol, description, ranks, color)
    local suit = {
        id = name:lower(),
        name = name,
        symbol = symbol,
        description = description,
        ranks = ranks,
        color = color,
        effects = {},
        modifiers = {},
image = love.graphics.newImage("assets/cards/" .. name:lower() .. ".png")  }

    return suit
end

function Suit.addEffect(suit, effect)
        table.insert(suit.effects, effect)

        return suit
end
function Suit.addModifier(suit, effect)
        table.insert(suit.modifiers, effect)

        return suit
end

function Suit.tostring(suit)
return suit.name .. "\n".."Color: ".. suit.color .. "\n \n" .. "Description: " .. suit.description
end
return Suit