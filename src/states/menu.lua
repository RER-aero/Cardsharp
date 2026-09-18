local State = require("src.game.state")
local Game = require("src.states.blackjack")
local Player = require("src.game.player")
local FontRenderer = require("src.render.font_renderer")
local Button = require("src.ui.button")
local suitselect = require("src.states.suitselect")
local Menu = {}


local playButton = Button.new("PLAY", love.graphics.getWidth()/2-100, 200, 200, 60)
local shopButton = Button.new("SHOP", love.graphics.getWidth()/2-100, 300, 150, 60)

function Menu.enter()
end

function Menu.update(dt)

end

function Menu.draw()
    FontRenderer.print("CARDSHARP", love.graphics.getWidth()/4, 80, 10)
Button.draw(playButton)
Button.draw(shopButton)

FontRenderer.print("CASH: " .. Player.cash .."$", 80, 50, 3)
   
end

function Menu.keypressed(key)

end
function Menu.mousepressed(x, y, button)
    if button == 1 then
    if Button.isHovered(playButton, x, y) then
        State.switch(suitselect)
    end
    if Button.isHovered(shopButton, x, y) then
        print("Shop button clicked. Shop functionality not implemented yet.")
    end
    end
end

return Menu