local Card = {}

function Card.new(rank, suit)
    local card = {
        rank = rank,
        suit = suit
    }

    return card
end

function Card.getValue(card)
    if card.rank == "A" then
        return 11
    elseif card.rank == "K"
        or card.rank == "Q"
        or card.rank == "J" then

        return 10
    else
        return tonumber(card.rank)
    end
end

return Card