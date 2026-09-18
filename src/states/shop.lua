local State = require("src.game.state")
local Menu = require("src.states.menu")
local FontRenderer = require("src.render.font_renderer")
local Button = require("src.ui.button")
local suitselect = require("src.states.suitselect")
local Shop = {}



function Shop.enter()
end

function Shop.update(dt)

end

function Shop.draw()
end

function Shop.keypressed(key)
    if key == "return" then
        State.switch(Menu)
    end
end
function Shop.mousepressed(x, y, button)
   
end

return Shop