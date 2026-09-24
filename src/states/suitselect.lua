local SuitSelection = {}

local Button = require("src.ui.button")
local FontRenderer = require("src.render.font_renderer")
local State = require("src.game.state")
local Deck = require("src.game.deck")
local Game = require("src.states.blackjack")
local Suit = require("src.game.suit")
local Player = require("src.game.player")

local suitSheet = love.graphics.newImage("assets/ui/suitselect.png")

local startButton = Button.new(
    "START",
    love.graphics.getWidth() / 2 + 200,
    600,
    200,
    60
)

local suitButtons = {}
local hoveredButton = nil

local GRID_COLUMNS = 5
local BUTTON_WIDTH = 128
local BUTTON_HEIGHT = 128
local HORIZONTAL_SPACING = 22
local VERTICAL_SPACING = 40
local START_X = 50
local START_Y = 200

local SPRITE_WIDTH = 32
local SPRITE_HEIGHT = 32
local SPRITE_SCALE = 4

SuitSelection.ActiveSuits = {}

local function createSuitButton(suit, index)
    local column = (index - 1) % GRID_COLUMNS
    local row = math.floor((index - 1) / GRID_COLUMNS)

    local x = START_X + column * (BUTTON_WIDTH + HORIZONTAL_SPACING)
    local y = START_Y + row * (BUTTON_HEIGHT + VERTICAL_SPACING)

    local spriteX = (suit.spriteIndex - 1) * SPRITE_WIDTH

    local quad = love.graphics.newQuad(
        spriteX,
        0,
        SPRITE_WIDTH,
        SPRITE_HEIGHT,
        suitSheet:getWidth(),
        suitSheet:getHeight()
    )

    local button = Button.new(
        "",
        x,
        y,
        BUTTON_WIDTH,
        BUTTON_HEIGHT,
        suitSheet,
        quad,
        SPRITE_SCALE,
        SPRITE_SCALE
    )

    button.suit = suit

    return button
end

function SuitSelection.enter()
    suitButtons = {}
    hoveredButton = nil

    for i, suit in ipairs(Player.ownedSuits) do
        local button = createSuitButton(suit, i)
        table.insert(suitButtons, button)
    end
end

function SuitSelection.update(dt)
    hoveredButton = nil

    for _, button in ipairs(suitButtons) do
        if Button.isHovered(
            button,
            love.mouse.getX(),
            love.mouse.getY()
        ) then
            hoveredButton = button
            break
        end
    end
end

function SuitSelection.draw()
    for _, button in ipairs(suitButtons) do
        Button.draw(button)

        if table.contains(SuitSelection.ActiveSuits, button.suit) then
            love.graphics.setColor(0, 1, 0, 0.5)

            love.graphics.rectangle(
                "fill",
                button.x,
                button.y,
                button.width,
                button.height
            )

            love.graphics.setColor(1, 1, 1, 1)
        end
    end

    if hoveredButton then
        FontRenderer.print(
            Suit.tostring(hoveredButton.suit):upper(),
            800,
            270,
            2,
            2,
            20
        )
    end
if #SuitSelection.ActiveSuits == 4 then
    Button.draw(startButton)
end
    FontRenderer.print(
        "SELECT SUITS",
        0,
        100,
        3,
        4,
        love.graphics.getWidth()
    )

    FontRenderer.print(
        "SELECTED SUITS: " .. #SuitSelection.ActiveSuits .. "/4",
        0,
        150,
        2,
        4,
        love.graphics.getWidth()
    )
end

function SuitSelection.mousepressed(x, y, button)
    if button ~= 1 then
        return
    end

    for _, suitButton in ipairs(suitButtons) do
        if Button.isHovered(suitButton, x, y) then
            local alreadySelected = false

            for i, suit in ipairs(SuitSelection.ActiveSuits) do
                if suit == suitButton.suit then
                    table.remove(SuitSelection.ActiveSuits, i)
                    alreadySelected = true
                    break
                end
            end

            if not alreadySelected then
                if #SuitSelection.ActiveSuits < 4 then
                    table.insert(
                        SuitSelection.ActiveSuits,
                        suitButton.suit
                    )
                end
            end

            return
        end
    end

    if Button.isHovered(startButton, x, y)
        and #SuitSelection.ActiveSuits == 4 then

        Game.ActiveSuits = SuitSelection.ActiveSuits
print("ACTIVE SUITS TYPE:", type(SuitSelection.ActiveSuits))

for i, suit in ipairs(SuitSelection.ActiveSuits) do
    print(
        i,
        "value:", suit,
        "type:", type(suit),
        "name:", suit.name,
        "ranks:", type(suit.ranks)
    )
end

Game.CurrentDeck = Deck.new(Game.ActiveSuits)
        Game.CurrentDeck = Deck.new(Game.ActiveSuits)
        Deck.shuffle(Game.CurrentDeck)

        State.switch(Game)
        Game.startRound()
    end
end

function SuitSelection.keypressed(key)
    if key == "escape" then
        State.switch(require("src.states.menu"))
    end
end

function table.contains(tbl, element)
    for _, value in pairs(tbl) do
        if value == element then
            return true
        end
    end

    return false
end

return SuitSelection