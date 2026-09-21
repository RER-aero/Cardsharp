local Cardrenderer = {}
local Hand = require("src.game.hand")
local Suits = require("src.game.suits")
local base = love.graphics.newImage("assets/cards/base.png")
local back = love.graphics.newImage("assets/cards/cardBack.png")

function Cardrenderer.draw(cards, initx, inity)
    if cards == nil then return end
    for i, card in ipairs(cards) do
         card.x = initx + (i - 1) * 60
         card.y = inity
         if card.sprite then
card.width = 19 * 4
card.height = 26 * 4
         end
     love.graphics.draw(back, card.x - 4.5, card.y - 4.5, 0, 4.5, 4.5)

if card.sprite then
    love.graphics.draw(base, card.x - 4.5, card.y - 4.5, 0, 4.5, 4.5)

    love.graphics.draw(card.spritesheet, card.sprite, card.x, card.y, 0, 4, 4)
end
    end
end
function Cardrenderer.isHovered(card, mouseX, mouseY)
    if card.x == nil or card.y == nil or card.width == nil or card.height == nil then
        return false
    end
    return mouseX >= card.x
        and mouseX <= card.x + card.width
        and mouseY >= card.y
        and mouseY <= card.y + card.height
end
return Cardrenderer
