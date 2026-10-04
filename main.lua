love.graphics.setDefaultFilter("nearest", "nearest")
local fontSheet
local Menu = require("src.states.menu")
local Player = require("src.game.player")
local Game = require("src.states.blackjack")
local Suits = require("src.game.suits")
local State = require("src.game.state")
local Save = require("src.game.save")


function love.load()
    local data = Save.loadPlayerData()

    if data then
        Player.cash = data.cash
        Player.ownedSuits = data.ownedSuits
    else
        Player.cash = 0
        Player.ownedSuits = {
            Suits.Hearts,
            Suits.Diamonds,
            Suits.Clubs,
            Suits.Spades
        }

        Save.savePlayerData(Player)
    end

    fontSheet = love.graphics.newImage("assets/ui/font.png")
    State.switch(Menu)
end

function love.mousepressed(x, y, button)
    State.mousepressed(x, y, button)
end

function love.update(dt)
    State.update(dt)
end

function love.draw()
   
    State.draw()
end

function love.keypressed(key)
    State.keypressed(key)
end
