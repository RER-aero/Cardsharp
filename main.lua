
local Menu = require("src.states.menu")
local Game = require("src.states.blackjack")
local State = require("src.game.state")


function love.load()
    State.switch(Menu)
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