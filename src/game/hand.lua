local Card = require("src.game.card")
local Modifier = require("src.game.modifier")
local Hand = {}

function Hand.new()
    return {}
end

function Hand.addCard(hand, card)
    table.insert(hand, card)
end
function Hand.getValue(hand, activeSuits)
    local value = 0
    local aces = 0

    for _, card in ipairs(hand) do
        local cardValue = Card.getValue(card, activeSuits)

        value = value + cardValue

        if card.rank == "A" then
            aces = aces + 1
        end
    end

    while value > 21 and aces > 0 do
        value = value - 10
        aces = aces - 1
    end

    return value
end

function Hand.containsAnyRank(hand, ranks)
    for _, card in ipairs(hand) do
        for _, rank in ipairs(ranks) do
            if card.rank == rank then
                return true
            end
        end
    end
    return false
end

function Hand.getCards(hand, showAll)
    local holding = {}
    for _, card in ipairs(hand) do
        local slice = " " .. card.rank .. " of " .. card.suit.name .. "\n"
        table.insert(holding, slice)
        if not showAll then
            break
        end
    end


    return holding
end

return Hand
