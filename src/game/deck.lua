local Card = require("src.game.card")

local Deck = {}

function Deck.new(suits)
    local deck = {}

    for _, suit in ipairs(suits) do
        for _, rank in ipairs(suit.ranks) do
            table.insert(deck, Card.new(rank, suit))
        end
    end

    return deck
end
function Deck.isEmpty(deck)
    return #deck == 0
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