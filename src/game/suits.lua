local Suits = {}
local Suit = require("src.game.suit")
local Hand = require("src.game.hand")
local Effect = require("src.game.effect")

function Diamonds()
    local diamonds = Suit.new("Diamonds", "♦", "Provides extra cash when dealer busts.")
    local effect = Effect.new(
        "dealer_bust",
        function(playerHand, dealerHand)
            print("Diamonds effect triggered: Player receives extra cash for dealer bust.")
        end
    )

    Suit.addEffect(diamonds, effect)

    return diamonds
end

return {
    Diamonds = Diamonds
}