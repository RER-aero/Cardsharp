
local Card = {}
local Modifier = require("src.game.modifier")

function Card.new(rank, suit)
    local spriteX

    if rank == "A" then
        spriteX = 0
    elseif rank == "K" then
        spriteX = 19
    elseif rank == "Q" then
        spriteX = 38
    elseif rank == "J" then
        spriteX = 57
    else
        spriteX = (5 + (10 - tonumber(rank)) - 1) * 19
    end

   local spritesheet = suit.image

local sprite = love.graphics.newQuad(
    spriteX,
    0,
    19,
    26,
    spritesheet:getWidth(),
    spritesheet:getHeight()
)

    local card = {
        rank = rank,
        suit = suit,
        color = suit.color,
        sprite = sprite,
        spritesheet = spritesheet
    }

    return card
end

function Card.getValue(card, activeSuits)
    local value

    if card.rank == "A" then
        value = 11
    elseif card.rank == "K"
        or card.rank == "Q"
        or card.rank == "J" then
        value = 10
    else
        value = tonumber(card.rank)
    end

    if activeSuits then
        value = Modifier.checkModifiers(
            activeSuits,
            card,
            value,
            "value"
        )
    end

    return value
end
function Card.toString(card, activeSuits)
    local value = Card.getValue(card, activeSuits)

    return card.rank .. " of " .. card.suit.name
        .. " Value: " .. value
        .. "\n" .. card.suit.color
        .. "\n" .. card.suit.description
end

return Card