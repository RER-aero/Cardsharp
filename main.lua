love.graphics.setDefaultFilter("nearest", "nearest")
local fontSheet
local Menu = require("src.states.menu")
local Game = require("src.states.blackjack")
local State = require("src.game.state")
Anim8 = require 'libraries/anim8'


function love.load()
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
