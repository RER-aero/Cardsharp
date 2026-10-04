local Save = {}
local Suits = require("src.game.suits")

function Save.savePlayerData(player)
    local data = {
        cash = player.cash,
        ownedSuits = {}
    }

    -- Convert suit objects into their names for saving
    for _, suit in ipairs(player.ownedSuits) do
        table.insert(data.ownedSuits, suit.name)
    end

    love.filesystem.createDirectory("player")

    local saveString = "return {\n"
        .. "    cash = " .. tostring(data.cash) .. ",\n"
        .. "    ownedSuits = {\n"

    for _, suitName in ipairs(data.ownedSuits) do
        saveString = saveString
            .. "        \"" .. suitName .. "\",\n"
    end

    saveString = saveString
        .. "    }\n"
        .. "}"

    love.filesystem.write("player/player_data.lua", saveString)
end

function Save.loadPlayerData()
    if not love.filesystem.getInfo("player/player_data.lua") then
        return nil
    end

    local data = love.filesystem.load("player/player_data.lua")()

    for i, suitName in ipairs(data.ownedSuits) do
        for _, suit in ipairs(Suits.AllSuits) do
            if suit.name == suitName then
                data.ownedSuits[i] = suit
                break
            end
        end
    end

    return data
end




return Save