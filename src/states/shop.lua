local State = require("src.game.state")
local Menu = require("src.states.menu")
local FontRenderer = require("src.render.font_renderer")
local Suit = require("src.game.suit")
local Button = require("src.ui.button")
local Player = require("src.game.player")
local Save = require("src.game.save")
local Suits = require("src.game.suits")

local Shop = {}

local backButton = Button.new(
    "BACK",
    love.graphics.getWidth() - 250,
    600,
    200,
    60
)

local purchaseButton = Button.new(
    "BUY",
    450,
    100,
    200,
    60
)

local suitSheet = love.graphics.newImage("assets/ui/shopselect.png")
local background = love.graphics.newImage("assets/ui/shop_bg.png")



local stockButtons = {}
local selectedSuit = nil
local sillyMessage = ""
local timer = 0

local function GetStockForTheDay(seed)
    local available = {}

    for _, suit in ipairs(Suits.AllSuits) do
        local isStarterSuit =
            suit == Suits.Diamonds or
            suit == Suits.Hearts or
            suit == Suits.Spades or
            suit == Suits.Clubs

        if not isStarterSuit and not table.contains(Player.ownedSuits, suit) then
            table.insert(available, suit)
        end
    end

    local stock = {}

    for i = 1, math.min(3, #available) do
        local index = (seed % #available) + 1

        table.insert(stock, available[index])
        table.remove(available, index)

        seed = (seed * 1103515245 + 12345) % 2147483648
    end

    return stock
end

local function createStockButton(suit, index)
    local spriteIndex = suit.spriteIndex - 4
    return Button.new(
        "",
        50 + (index - 1) * 120,
        90,
        90,
        112,
        suitSheet,
        love.graphics.newQuad(
            (spriteIndex - 1) * 90,
            0,
            90,
            112,
            suitSheet:getWidth(),
            suitSheet:getHeight()
        ),
        1.25,
        1.25,
        suit.name
    )
end

local function refreshStock()
    stockButtons = {}
    selectedSuit = nil

    local shopDate = tonumber(os.date("%y%m%d"))
    local stock = GetStockForTheDay(shopDate)

    for i, suit in ipairs(stock) do
        table.insert(stockButtons, {
            button = createStockButton(suit, i),
            suit = suit
        })
    end
end

function Shop.enter()
    sillyMessage = ""
    timer = 0
    refreshStock()
end

function Shop.update(dt)
    if sillyMessage ~= "" then
        timer = timer + dt

        if timer >= 3 then
            sillyMessage = ""
        end
    end
end

function Shop.draw()
    love.graphics.draw(background, 0, 0)

    FontRenderer.print("Suits: 15$ a pop", 0, 1, 4)
    FontRenderer.print("CASH: " .. Player.cash .. "$", 900, 100, 3)

    Button.draw(backButton)

    if selectedSuit ~= nil then
        Button.draw(purchaseButton)
    end

    for _, stock in ipairs(stockButtons) do
        Button.draw(stock.button)

        if Button.isHovered(
            stock.button,
            love.mouse.getX(),
            love.mouse.getY()
        ) then
            FontRenderer.print(
                Suit.tostring(stock.suit),
                800,
                300,
                2,
                2,
                20
            )
        end
    end

    for _, stock in ipairs(stockButtons) do
        if selectedSuit == stock.suit then
            love.graphics.setColor(0, 1, 0, 0.5)

            love.graphics.rectangle(
                "fill",
                stock.button.x,
                stock.button.y,
                stock.button.width * stock.button.scalex,
                stock.button.height * stock.button.scaley
            )

            love.graphics.setColor(1, 1, 1, 1)
        end
    end

    if sillyMessage ~= "" then
        FontRenderer.print(
            sillyMessage,
            850,
            200,
            2,
            2,
            20
        )
    end
end

function Shop.keypressed(key)
    if key == "return" then
        State.switch(Menu)
    end
end

function Shop.mousepressed(x, y, button)
    if button ~= 1 then
        return
    end

    if Button.isHovered(backButton, x, y) then
        State.switch(Menu)
        return
    end

    for _, stock in ipairs(stockButtons) do
        if Button.isHovered(stock.button, x, y) then
            if selectedSuit == stock.suit then
                selectedSuit = nil
            else
                selectedSuit = stock.suit
            end

            return
        end
    end

    if Button.isHovered(purchaseButton, x, y) and selectedSuit ~= nil then
        if Player.cash >= 15 then
            Player.cash = Player.cash - 15
            table.insert(Player.ownedSuits, selectedSuit)

            Save.savePlayerData(Player)

            for i, stock in ipairs(stockButtons) do
                if stock.suit == selectedSuit then
                    table.remove(stockButtons, i)
                    break
                end
            end

            selectedSuit = nil
        else
            timer = 0
            sillyMessage = "Bro can't even afford this suit, get a job!!!! LMAO"
        end
    end
end

return Shop