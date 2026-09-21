local Game = {}
local Player = require("src.game.player")
local State = require("src.game.state")
local Suits = require("src.game.suits")
local Deck = require("src.game.deck")
local Hand = require("src.game.hand")
local Effect = require("src.game.effect")
local Cardrenderer = require("src.render.card_renderer")
local FontRenderer = require("src.render.font_renderer")
local Card = require("src.game.card")
local Button = require("src.ui.button")
function Game.enter()
    Game.round = 0
    Game.chips = 0
    Game.AvailableSuits = {
        Suits.Diamonds,
        Suits.Hearts,
        Suits.Bones,
        Suits.Feathers,
        Suits.Stars,
        Suits.Pentacles,
        Suits.Bells,
        Suits.Crowns,
        Suits.Spades,
        Suits.Clubs
    }


end
local cashoutButton
local continueButton 
function Game.startRound()
    if Game.CurrentDeck == nil or #Game.CurrentDeck < 4 then
        print("Not enough cards to start a round.")
        return
    end
    Game.roundResult = nil
    Game.PlayerHand = Hand.new()
    Game.DealerHand = Hand.new()

    Hand.addCard(Game.PlayerHand, Deck.draw(Game.CurrentDeck))
    Hand.addCard(Game.PlayerHand, Deck.draw(Game.CurrentDeck))

    Hand.addCard(Game.DealerHand, Deck.draw(Game.CurrentDeck))
    Hand.addCard(Game.DealerHand, Deck.draw(Game.CurrentDeck))
    local PlayerHandAsString = Hand.getCards(Game.PlayerHand, true)
    print("Player Hand: \n" ..
        table.concat(PlayerHandAsString) .. " Value: " .. Hand.getValue(Game.PlayerHand, Game.ActiveSuits))
    local DealerHandAsString = Hand.getCards(Game.DealerHand, false)
    print("Dealer Hand: \n" ..
        table.concat(DealerHandAsString) .. " Value:  " .. Hand.getValue({ Game.DealerHand[1] }, Game.ActiveSuits))
    Game.round = Game.round + 1
    Game.phase = "player"
end

function Game.update(dt)
    if Game.phase == "dealer" then
        local DealerHandVal = Hand.getValue(Game.DealerHand, Game.ActiveSuits)
        local PlayerHandVal = Hand.getValue(Game.PlayerHand, Game.ActiveSuits)
        while DealerHandVal < 17 do
            Hand.addCard(Game.DealerHand, Deck.draw(Game.CurrentDeck))
            DealerHandVal = Hand.getValue(Game.DealerHand, Game.ActiveSuits)
        end

        local DealerHandAsString = Hand.getCards(Game.DealerHand, true)
        print("Dealer Hand: \n" ..
            table.concat(DealerHandAsString) .. " Value: " .. Hand.getValue(Game.DealerHand, Game.ActiveSuits))


        if DealerHandVal > 21 then
            print("Dealer busts! Player wins.")

            Game.finishRound("player_wins", "dealer_bust")
        elseif DealerHandVal > PlayerHandVal then
            Game.finishRound("dealer_wins")
        elseif DealerHandVal < PlayerHandVal then
            print("Player wins.")
            Game.finishRound("player_wins")
        else
            print("It's a tie!")

            Game.finishRound("tie")
        end
    end
   
end

function Game.finishRound(result, trigger)
    local rewards = {
        player_wins = 10,
        dealer_wins = 0,
        tie = 5,
        blackjack = 15
    }

    Game.roundResult = result
    local context = {
        playerHand = Game.PlayerHand,
        dealerHand = Game.DealerHand,
        activeSuits = Game.ActiveSuits,
        game = Game
    }
    Effect.checkTriggers(Game.ActiveSuits, context, result)

    if trigger then
        Effect.checkTriggers(Game.ActiveSuits, context, trigger)
    end

    Effect.checkTriggers(Game.ActiveSuits, context, "round_over")

    Game.chips = Game.chips + rewards[result]

    print("Round reward: " .. rewards[result])
    print("Current chips: " .. Game.chips)

    if Game.round % 5 == 0 then
        Game.phase = "intermission"
         continueButton = Button.new("Continue", 400, 400, 500, 50)
         cashoutButton = Button.new("Cashout for " .. tostring(math.floor(Game.chips / 10)) .. " $", 400, 300, 700, 50)
    else
        Game.phase = "roundOver"
    end
end
  local  background = love.graphics.newImage("assets/ui/game_bg.png")
function Game.draw()
    love.graphics.draw(background, 0, 0)
    if Game.phase == "intermission" then
        Button.draw(cashoutButton)
        Button.draw(continueButton)
       FontRenderer.print("Cashout will convert your chips into permanent cash.", 400, 350)
      

        return
    end
   

    Cardrenderer.draw(Game.PlayerHand, 510, 300)
    love.graphics.print("Player: " .. Hand.getValue(Game.PlayerHand, Game.ActiveSuits), 300, 300)

    if Game.phase == "player" then
        Cardrenderer.draw({  {
            rank = "?",
            suit = "unknownSuit"
        }, Game.DealerHand[1] }, 510, 100)
        FontRenderer.print("Dealer: " .. Hand.getValue({ Game.DealerHand[1] }, Game.ActiveSuits), 740, 100)
    else
        Cardrenderer.draw(Game.DealerHand, 510, 100)
        FontRenderer.print("Dealer: " .. Hand.getValue(Game.DealerHand, Game.ActiveSuits), 740, 100)
    end
    if Game.phase == "roundOver" then
        if Game.roundResult == "player_wins" then
            FontRenderer.print("Player wins! Press Space to play again.", 400, 450)
        elseif Game.roundResult == "dealer_wins" then
            FontRenderer.print("Dealer wins! Press Space to play again.", 400, 450)
        elseif Game.roundResult == "tie" then
            FontRenderer.print("It's a tie! Press Space to play again.", 400, 450)
        elseif Game.roundResult == "blackjack" then
            FontRenderer.print("BLACKJACK! Press Space to play again.", 400, 450)
        end
    end
     for _, card in ipairs(Game.PlayerHand) do
        if Cardrenderer.isHovered(card, love.mouse.getX(), love.mouse.getY()) then
            print("hovering")
            FontRenderer.print(Card.toString(card, Game.ActiveSuits):upper(),  900 , card.y - 80,2)
        end
    end
end

function Game.mousepressed(x, y, button)
    if button ~= 1 then
        return
    end
   
    if Game.phase == "intermission" then
      if Button.isHovered(cashoutButton, love.mouse.getX(), love.mouse.getY()) then
            Game.cashOut()
        elseif Button.isHovered(continueButton, love.mouse.getX(), love.mouse.getY()) then
            print("Continue selected. Starting next round.")
            Game.startRound()
        end
    end
end

function Game.cashOut()
    local cash = math.floor(Game.chips / 10)
    Player.cash = Player.cash + cash
    print("Cashout selected.")
    print("Converted " .. Game.chips .. " chips into " .. cash .. " cash.")
    print("Permanent cash: " .. Player.cash)
    Game.endRun()
end

function Game.endRun()
    local Menu = require("src.states.menu")
    local Save = require("src.game.save")

    print("Game Over. Thanks for playing!")
    Save.savePlayerData(Player)
    State.switch(Menu)
end

function Game.addChips(chips)
    Game.chips = Game.chips + chips
    print("Added " .. chips .. " chips. Total chips: " .. Game.chips)
end

function Game.keypressed(key)
    local PlayerHandAsString
    if key == "h" and Game.phase == "player" then
        Hand.addCard(Game.PlayerHand, Deck.draw(Game.CurrentDeck))
        PlayerHandAsString = Hand.getCards(Game.PlayerHand, true)
        print("Player Hand: \n" ..
            table.concat(PlayerHandAsString) .. " Value: " .. Hand.getValue(Game.PlayerHand, Game.ActiveSuits))
        if Hand.getValue(Game.PlayerHand, Game.ActiveSuits) > 21 then
            print("Player busts! Dealer wins.")
            Game.finishRound("dealer_wins")
        end
    end
    if key == "s" and Game.phase == "player" then
        if Hand.getValue(Game.PlayerHand, Game.ActiveSuits) == 21 and #Game.PlayerHand == 2 then
            print("Player gets a blackjack!")
            Game.finishRound("blackjack")
        else
            Game.phase = "dealer"
            print("Player stands. Dealer's turn.")
        end
    end
    if key == "space" and Game.phase == "roundOver" then
        Game.startRound()
    end
end



return Game
