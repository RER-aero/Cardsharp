local State = require("src.game.state")
local Menu = require("src.states.menu")
local FontRenderer = require("src.render.font_renderer")
local Suit = require("src.game.suit")
local Button = require("src.ui.button")
local suitselect = require("src.states.suitselect")
local Player = require("src.game.player")
local Shop = {}
local backButton = Button.new("BACK", love.graphics.getWidth() - 250, 600, 200, 60)
local suitSheet = love.graphics.newImage("assets/ui/shopselect.png")
local Suits = require("src.game.suits")
local shopDate = tonumber(os.date("%y%m%d"))
local shopSpriteIndex = {
    [Suits.Bones] = 1,
    [Suits.Feathers] = 2,
    [Suits.Stars] = 3,
    [Suits.Pentacles] = 4,
    [Suits.Crowns] = 5,
    [Suits.Bells] = 6
}


local stockButtons = {}
function table.indexof(t, value)
    for i, v in ipairs(t) do
        if v == value then
            return i
        end
    end
    return nil
end
local function GetStockForTheDay(seed)
    local available = {}
    

    -- Build a list of suits the player doesn't own
    for _, suit in ipairs(suitselect.AvailableSuits) do
        if not table.contains(Player.ownedSuits, suit) then
            table.insert(available, suit)
        end
    end

    local stock = {}

    -- Pick up to 4 suits
    for i = 1, math.min(3, #available) do
        -- Generate a deterministic index from the date
        local index = (seed % #available) + 1

        table.insert(stock, available[index])
        table.remove(available, index)

        -- Change the seed for the next selection
        seed = (seed * 1103515245 + 12345) % 2147483648
    end

    return stock
end

local inStock = GetStockForTheDay(shopDate)
inStock = GetStockForTheDay(shopDate)
function Shop.enter()
    stockButtons = {}

    -- Recalculate in case the player bought something
    inStock = GetStockForTheDay(shopDate)

    for i, suit in ipairs(inStock) do
        print("SHOP SLOT", i, "=", suit.name)
        local button = Button.new(
            "",
            50 + (i - 1) * 120,
            90,
            90,
            112,
            suitSheet,
            love.graphics.newQuad(
                (shopSpriteIndex[suit] - 1) * 90,
                0,
                90,
                112,
                suitSheet:getWidth(),
                suitSheet:getHeight()
            ),
            1.25,
            1.25
        )
        print("Adding suit to stock: " .. suit.name)
        table.insert(stockButtons, {
            button = button,
            suit = suit
        })

        print("BUTTON", i, "=", stockButtons[#stockButtons].suit.name)
    end
end

function Shop.update(dt)

end

local background = love.graphics.newImage("assets/ui/shop_bg.png")
function Shop.draw()
    love.graphics.draw(background, 0, 0)
FontRenderer.print("Suits: 15$ a pop", 0, 1, 4)
FontRenderer.print("CASH: " .. Player.cash .."$",  900, 100, 3)
    Button.draw(backButton)
    for _, button in ipairs(stockButtons) do
        Button.draw(button.button)
        if Button.isHovered(button.button, love.mouse.getX(), love.mouse.getY()) then
            FontRenderer.print(Suit.tostring(button.suit), 800, 100, 2, 2, 20)
        end
    end
end

function Shop.keypressed(key)
    if key == "return" then
        State.switch(Menu)
    end
end

function Shop.mousepressed(x, y, button)
    if button == 1 then
        if Button.isHovered(backButton, x, y) then
            State.switch(Menu)
        end
        for _, stock in ipairs(stockButtons) do
            if Button.isHovered(stock.button, x, y) then
                local suit = stock.suit
                if Player.cash >= 100 then
                    if not table.contains(Player.ownedSuits, suit) then
                        Player.cash = Player.cash - 100
                        table.insert(Player.ownedSuits, suit)
                        print("Purchased suit: " .. suit.name)
                        State.switch(Shop)
                    else
                        print("You already own this suit: " .. suit.name)
                    end
                else
                    print("Not enough cash to purchase: " .. suit.name)
                end
            end
        end
    end
end



return Shop
