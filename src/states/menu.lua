local State = require("src.game.state")
local Game = require("src.states.blackjack")

local Menu = {}

function Menu.enter()
end

function Menu.update(dt)

end

function Menu.draw()
    love.graphics.printf(
        "SUITS",
        0,
        100,
        love.graphics.getWidth(),
        "center"
    )

    love.graphics.printf(
        "Press ENTER to Start",
        0,
        200,
        love.graphics.getWidth(),
        "center"
    )
end

function Menu.keypressed(key)
    if key == "return" then
        State.switch(Game)
    end
end

return Menu