local Game = {}
local Suits = require("src.game.suits")
local Deck = require("src.game.deck")
local Hand = require("src.game.hand")
local Effect = require("src.game.effect")
local Cardrenderer = require("src.render.card_renderer")
function Game.enter()
  
    Game.CurrentDeck = Deck.new()
Game.ActiveSuits = {Suits.Diamonds()}
    Deck.shuffle(Game.CurrentDeck)
Game.startRound()
 
end
function Game.startRound()
   Game.PlayerHand = Hand.new()
    Game.DealerHand = Hand.new()

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
            Effect.checkTriggers(Game.ActiveSuits, Game.PlayerHand, Game.DealerHand, "dealer_bust")
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
   Cardrenderer.draw(Game.PlayerHand, 100)

if Game.phase == "player" then
      Cardrenderer.draw({Game.DealerHand[1], {rank = "?", suit = "unknownSuit"}}, 800)

else
     Cardrenderer.draw(Game.DealerHand, 800)

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
     if key == "space" and Game.phase == "roundOver" then
        Game.startRound()
    end
end

return Game
