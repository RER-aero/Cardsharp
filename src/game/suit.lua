local Suit = {}


function Suit.new(name, description, ranks, color, spriteIndex)
    local suit = {
        id = name:lower(),
        name = name,
        description = description,
        ranks = ranks,
        color = tostring(color),
        effects = {},
        modifiers = {},
image = love.graphics.newImage("assets/cards/" .. name:lower() .. ".png"),
    spriteIndex = tonumber(spriteIndex) or 1
    }
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