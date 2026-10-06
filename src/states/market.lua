local State = require("src.game.state")
local Game = require("src.states.blackjack")
local FontRenderer = require("src.render.font_renderer")
local Button = require("src.ui.button")
local Upgrades = require("src.game.upgrades")

local Market = {}

local continueButton = Button.new(
    "CONTINUE",
    800,
    600,
    250,
    60
)

local purchaseButton = Button.new(
    "BUY",
    450,
    500,
    200,
    60
)

local background = love.graphics.newImage("assets/ui/game_bg.png")

local stockButtons = {}
local selectedUpgrade = nil
local sillyMessage = ""
local timer = 0

local function getAvailableUpgrades()
    local available = {}

    for _, upgrade in pairs(Upgrades.allUpgrades) do
        local alreadyOwned = false

        for _, ownedUpgrade in ipairs(Game.activeUpgrades) do
            if ownedUpgrade == upgrade then
                alreadyOwned = true
                break
            end
        end

        if not alreadyOwned then
            table.insert(available, upgrade)
        end
    end

    return available
end

local function getStock()
    local available = getAvailableUpgrades()
    local stock = {}

    while #stock < math.min(3, #available) do
        local index = love.math.random(1, #available)

        table.insert(stock, available[index])
        table.remove(available, index)
    end

    return stock
end

local function createStockButton(upgrade, index)
    return Button.new(
        upgrade.name,
        100 + (index - 1) * 300,
        150,
        250,
        200      
    )
end

local function refreshStock()
    stockButtons = {}
    selectedUpgrade = nil

    local stock = getStock()

    for i, upgrade in ipairs(stock) do
        table.insert(stockButtons, {
            button = createStockButton(upgrade, i),
            upgrade = upgrade
        })
    end
end

function Market.enter()
    sillyMessage = ""
    timer = 0
    refreshStock()
end

function Market.update(dt)
    if sillyMessage ~= "" then
        timer = timer + dt

        if timer >= 3 then
            sillyMessage = ""
        end
    end
end

function Market.draw()
    love.graphics.draw(background, 0, 0)

    FontRenderer.print(
        "MARKET",
        100,
        50,
        4
    )

    FontRenderer.print(
        "CHIPS: " .. Game.chips,
        900,
        100,
        3
    )

    Button.draw(continueButton)

    if selectedUpgrade ~= nil then
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
                stock.upgrade.name ..
                "\n\n" ..
                stock.upgrade.description ..
                "\n\nCost: " ..
                stock.upgrade.cost ..
                " chips",
                800,
                300,
                2,
                2,
                20
            )
        end
    end

    for _, stock in ipairs(stockButtons) do
        if selectedUpgrade == stock.upgrade then
            love.graphics.setColor(0, 1, 0, 0.5)

            love.graphics.rectangle(
                "fill",
                stock.button.x,
                stock.button.y,
                stock.button.width * (stock.button.scalex or 1),
                stock.button.height * (stock.button.scaley or 1)
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

function Market.keypressed(key)
    if key == "return" then
        Game.startRound()
        State.switch(Game)
    end
end

function Market.mousepressed(x, y, button)
    if button ~= 1 then
        return
    end

    if Button.isHovered(continueButton, x, y) then
        Game.startRound()
        State.switch(Game)
        return
    end

    for _, stock in ipairs(stockButtons) do
        if Button.isHovered(stock.button, x, y) then
            if selectedUpgrade == stock.upgrade then
                selectedUpgrade = nil
            else
                selectedUpgrade = stock.upgrade
            end

            return
        end
    end

    if Button.isHovered(purchaseButton, x, y)
        and selectedUpgrade ~= nil then

        if Game.chips >= selectedUpgrade.cost then
            Game.chips = Game.chips - selectedUpgrade.cost

            Game.addUpgrade(selectedUpgrade)

            for i, stock in ipairs(stockButtons) do
                if stock.upgrade == selectedUpgrade then
                    table.remove(stockButtons, i)
                    break
                end
            end

            selectedUpgrade = nil
        else
            timer = 0
            sillyMessage = "Not enough chips!"
        end
    end
end

return Market