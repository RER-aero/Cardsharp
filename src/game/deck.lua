local Card = require("src.game.card")

local Deck = {}

function Deck.new()
    local deck = {}

    local suits = {
        "hearts",
        "diamonds",
        "clubs",
        "spades"
    }

    local ranks = {
        "A", "2", "3", "4", "5",
        "6", "7", "8", "9", "10",
        "J", "Q", "K"
    }

    for _, suit in ipairs(suits) do
        for _, rank in ipairs(ranks) do
            table.insert(deck, Card.new(rank, suit))
        end
    end

    return deck
end

function Deck.shuffle(deck)
    for i = #deck, 2, -1 do
        local j = love.math.random(i)

        deck[i], deck[j] = deck[j], deck[i]
    end
end

function Deck.draw(deck)
    return table.remove(deck)
end

return Deck