local Game = {}

local Deck = require("src.game.deck")
local Hand = require("src.game.hand")

function Game.enter()
    Game.DealerHand = Hand.new()

    Game.PlayerHand = Hand.new()
    Game.CurrentDeck = Deck.new()
    Deck.shuffle(Game.CurrentDeck)

    Hand.addCard(Game.PlayerHand, Deck.draw(Game.CurrentDeck))
    Hand.addCard(Game.PlayerHand, Deck.draw(Game.CurrentDeck))

    Hand.addCard(Game.DealerHand, Deck.draw(Game.CurrentDeck))
    Hand.addCard(Game.DealerHand, Deck.draw(Game.CurrentDeck))
    local PlayerHandAsString = Hand.getCards(Game.PlayerHand, true)
    print("Player Hand: \n" .. table.concat(PlayerHandAsString) .. " Value: " .. Hand.getValue(Game.PlayerHand))
    local DealerHandAsString = Hand.getCards(Game.DealerHand, false)
    print("Dealer Hand: \n" .. table.concat(DealerHandAsString) .. " Value:  " .. Hand.getValue({ Game.DealerHand[1] }))
    Game.phase = "player"
end

function Game.update(dt)
    if Game.phase == "dealer" then
        local DealerHandVal = Hand.getValue(Game.DealerHand)
        local PlayerHandVal = Hand.getValue(Game.PlayerHand)
        while DealerHandVal < 17 do
            Hand.addCard(Game.DealerHand, Deck.draw(Game.CurrentDeck))
            DealerHandVal = Hand.getValue(Game.DealerHand)
        end

        local DealerHandAsString = Hand.getCards(Game.DealerHand, true)
        print("Dealer Hand: \n" .. table.concat(DealerHandAsString) .. " Value: " .. Hand.getValue(Game.DealerHand))

        if DealerHandVal > 21 then
            print("Dealer busts! Player wins.")
        elseif DealerHandVal > PlayerHandVal then
            print("Dealer wins.")
        elseif DealerHandVal < PlayerHandVal then
            print("Player wins.")
        else
            print("It's a tie!")
        end

        Game.phase = "roundOver"
    end
end

function Game.draw()
    love.graphics.printf(
        "Press H to Hit or S to Stand",
        0,
        300,
        love.graphics.getWidth(),
        "center"
    )

    for C, card in ipairs(Game.PlayerHand) do
        love.graphics.printf(
            card.rank .. " of " .. card.suit,
            0,
            350 + (C - 1) * 20,
            love.graphics.getWidth(),
            "center"
        )
    end
    love.graphics.printf(
        "Dealers Hand: ",
        0,
        450,
        love.graphics.getWidth(),
        "center"
    )

    if Game.phase == "player" then
        love.graphics.printf(
            Game.DealerHand[1].rank .. " of " .. Game.DealerHand[1].suit,
            0,
            500,
            love.graphics.getWidth(),
            "center"
        )
           love.graphics.printf(
           "Mystery Card",
            0,
            520,
            love.graphics.getWidth(),
            "center"
        )
    end
    if Game.phase == "dealer" or Game.phase == "roundOver" then
        for C, card in ipairs(Game.DealerHand) do
            love.graphics.printf(
                card.rank .. " of " .. card.suit,
                0,
                500 + (C - 1) * 20,
                love.graphics.getWidth(),
                "center"
            )
        end
    end
end

function Game.keypressed(key)
    local PlayerHandAsString
    if key == "h" and Game.phase == "player" then
        Hand.addCard(Game.PlayerHand, Deck.draw(Game.CurrentDeck))
        PlayerHandAsString = Hand.getCards(Game.PlayerHand, true)
        print("Player Hand: \n" .. table.concat(PlayerHandAsString) .. " Value: " .. Hand.getValue(Game.PlayerHand))
        if Hand.getValue(Game.PlayerHand) > 21 then
            print("Player busts! Dealer wins.")
            Game.phase = "roundOver"
        end
    end
    if key == "s" and Game.phase == "player" then
        Game.phase = "dealer"
        print("Player stands. Dealer's turn.")
    end
end

return Game
