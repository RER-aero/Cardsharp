local Cardrenderer = {}
local Hand = require("src.game.hand")

function Cardrenderer.draw(cards, init)
    local stringSymbols = {
        diamonds = "♦",
        hearts = "♥",
        clubs = "♣",
        spades = "♠",
        unknownSuit = "?"
    }

    for i, card in ipairs(cards) do
        local x = init + (i - 1) * 120
        local y = 200

        love.graphics.rectangle("line", x, y, 100, 150)
        love.graphics.printf(card.rank .. " of " .. stringSymbols[card.suit], x, y + 60, 100, "center")
    end
end

return Cardrenderer
