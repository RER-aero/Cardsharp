local Card = require("src.game.card")

local Hand = {}

function Hand.new()
    return {}
end

function Hand.addCard(hand, card)
    table.insert(hand, card)
end

function Hand.getValue(hand)

    local value = 0
    local aces = 0

    for _, card in ipairs(hand) do
        value = value + Card.getValue(card)

        if card.rank == "A" then
            aces = aces + 1
        end
    end

    -- Convert Aces from 11 to 1 if needed
    while value > 21 and aces > 0 do
        value = value - 10
        aces = aces - 1
    end

    return value
end


function Hand.getCards(hand, showAll)
local holding = {}
    for _, card in ipairs(hand) do
        local slice = " ".. card.rank .. " of " .. card.suit .. "\n" 
        table.insert(holding, slice)
       if not showAll then
            break
        end
    end


    return holding
end

return Hand