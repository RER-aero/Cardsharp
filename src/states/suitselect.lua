local SuitSelection = {}
local Button = require("src.ui.button")
local FontRenderer = require("src.render.font_renderer")
local State = require("src.game.state")
local Suits = require("src.game.suits")
local Deck = require("src.game.deck")
local suitSheet = love.graphics.newImage("assets/ui/suitselect.png")
local Game = require("src.states.blackjack")
local Suit = require("src.game.suit")
local suitButtons = {}
local startButton = Button.new("START", love.graphics.getWidth()/2-100, 600, 200, 60)
SuitSelection.AvailableSuits = {
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

SuitSelection.ActiveSuits = {}

function SuitSelection.enter()
    suitButtons = {}
    print("Entered suit selection")
    for i, suit in ipairs(SuitSelection.AvailableSuits) do
        local xpos = 50 + (i - 1) * 150 - (math.floor((i - 1) / 5) * 750)

        local ypos = 200 * (math.floor((i - 1) / 5) + 1)
      local button = Button.new(
    "",
    xpos,
    ypos,
    128,
    128,
    suitSheet,
    love.graphics.newQuad(
        (i - 1) * 32,
        0,
        32,
        32,
        suitSheet:getWidth(),
        suitSheet:getHeight()
    )
)

button.suit = suit

table.insert(suitButtons, button)
    end
end
local hoveredButton
function SuitSelection.update(dt)
    for _, button in ipairs(suitButtons) do
        if Button.isHovered(button, love.mouse.getX(), love.mouse.getY()) then
            hoveredButton = button
            break
        end
        hoveredButton = nil
    end
end

function SuitSelection.draw()
    for i, button in ipairs(suitButtons) do
       Button.draw(button)
        if table.contains(SuitSelection.ActiveSuits, button.suit) then
            love.graphics.setColor(0, 1, 0, 0.5)
            love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
    if hoveredButton then
            -- FontRenderer.print(hoveredButton.suit.name:upper(), 850, 200 - 30, 2, 4, 100)
            -- FontRenderer.print(hoveredButton.suit.description:upper(), 800, 250 - 30, 2, 2, 20)
            FontRenderer.print(Suit.tostring(hoveredButton.suit):upper(), 800, 300 - 30, 2, 2, 20)
    end
Button.draw(startButton)
    FontRenderer.print("SELECT SUITS", 0, 100, 3, 4, love.graphics.getWidth())
    FontRenderer.print("SELECTED SUITS: " .. #SuitSelection.ActiveSuits .. "/4", 0, 150, 2, 4, love.graphics.getWidth())
end
function SuitSelection.mousepressed(x, y, button)
    if button ~= 1 then
        return
    end

    for _, suitButton in ipairs(suitButtons) do
        if Button.isHovered(suitButton, x, y) then

            if not table.contains(SuitSelection.ActiveSuits, suitButton.suit) and #SuitSelection.ActiveSuits < 4 then
                table.insert(SuitSelection.ActiveSuits, suitButton.suit)
            else
                for i, suit in ipairs(SuitSelection.ActiveSuits) do
                    if suit == suitButton.suit then
                        table.remove(SuitSelection.ActiveSuits, i)
                        break
                    end
                end
            end

            for _, suit in ipairs(SuitSelection.ActiveSuits) do
                print(suit.name)
            end
        end
    end
  if Button.isHovered(startButton, x, y) and #SuitSelection.ActiveSuits == 4 then
    Game.ActiveSuits = SuitSelection.ActiveSuits

    Game.CurrentDeck = Deck.new(Game.ActiveSuits)
    Deck.shuffle(Game.CurrentDeck)

    State.switch(Game)
    Game.startRound()
end
end

function SuitSelection.keypressed(key)
if key == "escape" then
        State.switch(require("src.states.menu")
)
    end
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

return SuitSelection
